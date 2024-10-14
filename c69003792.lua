--メガリス・アンフォームド
---@param c Card
function c69003792.initial_effect(c)
	--attack down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69003792,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c69003792.atktg)
	e1:SetOperation(c69003792.atkop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69003792,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c69003792.sptg)
	e2:SetOperation(c69003792.spop)
	c:RegisterEffect(e2)
end
function c69003792.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c69003792.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69003792.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c69003792.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c69003792.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c69003792.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP_DEFENSE) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv*2,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv*2,tp,c,lv*2,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c69003792.rfilter(c,e,tp)
	return c:IsSetCard(0x138)
end
function c69003792.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c69003792.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,c69003792.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal") end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c69003792.spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c69003792.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,c69003792.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel()*2,"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel()*2,tp,tc,tc:GetLevel()*2,"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_DEFENSE)
		tc:CompleteProcedure()
	end
end
