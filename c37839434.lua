--剣鬼の神域
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1e4) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x1e4,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER)
	local ch=Duel.GetCurrentChain()
	local b2=false
	local og=Group.CreateGroup()
	local tsp=-1
	local tse=nil
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	if ch>0 then
		tsp,tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		og:AddCard(tse:GetHandler())
		b2=tsp==1-tp and not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) and tse:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
	end
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DISABLE)
		end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local c=e:GetHandler()
		if c:IsRelateToChain() and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x1e4,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) then
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
				local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,sg:GetFirst(),nil)
				end
			end
		end
	elseif e:GetLabel()==2 then
		local ch=Duel.GetCurrentChain()
		Duel.NegateEffect(ch-1)
	end
end
