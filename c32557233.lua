--六花深々
---@param c Card
function c32557233.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32557233,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,32557233+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32557233.target)
	e1:SetOperation(c32557233.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32557233,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,32557233+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c32557233.cost)
	e2:SetTarget(c32557233.target2)
	e2:SetOperation(c32557233.activate2)
	c:RegisterEffect(e2)
end
function c32557233.spfilter(c,e,tp,check)
	return c:IsSetCard(0x141) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (check or Duel.IsExistingMatchingCard(c32557233.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp))
end
function c32557233.spfilter2(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c32557233.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c32557233.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c32557233.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32557233.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c32557233.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1 and (c:IsControler(tp) or c:IsFaceup())
		and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function c32557233.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c32557233.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c32557233.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c32557233.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	if chk==0 then
		e:SetLabel(0)
		return res and e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and Duel.IsExistingMatchingCard(c32557233.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsPlayerCanSpecialSummonCount(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c32557233.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32557233.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,true)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		if e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c32557233.spfilter2),tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32557233.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
