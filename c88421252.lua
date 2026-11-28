--カウンターマジック「攻撃の無力化」
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local b1=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
		and a~=nil and a:IsControler(1-tp) and a:IsType(TYPE_MONSTER)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ch=Duel.GetCurrentChain()
	local b2=false
	local og=Group.CreateGroup()
	local tsp=-1
	local tse=nil
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	if ch>0 then
		tsp,tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		og:AddCard(tse:GetHandler())
		if tsp==1-tp and tse and tse:IsActiveType(TYPE_MONSTER) then
			b2=true
		end
	end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(0)
		end
	else
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
		if tse and tse:GetHandler():IsDestructable() and tse:GetHandler():IsRelateToEffect(tse) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,og,1,0,0)
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.NegateAttack() then
			Duel.BreakEffect()
			Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	elseif e:GetLabel()==2 then
		local ch=Duel.GetCurrentChain()-1
		local tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
		if Duel.NegateEffect(ch) and tse:GetHandler():IsRelateToChain(ch) then
			Duel.Destroy(tse:GetHandler(),REASON_EFFECT)
		end
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE and Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
