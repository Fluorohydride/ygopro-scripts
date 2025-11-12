--デーモンの諧謔
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,58769832,85154941,11248645)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x45) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cspfilter(c,e,tp)
	return c:IsCode(58769832,85154941,11248645) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x45) and c:IsType(TYPE_RITUAL)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.cspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		local g=Duel.GetMatchingGroup(s.cspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and #g>0 then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(3,ft))
			if sg then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
