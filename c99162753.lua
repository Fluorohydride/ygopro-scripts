--セクステット・サモン
function c99162753.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99162753+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99162753.target)
	e1:SetOperation(c99162753.activate)
	c:RegisterEffect(e1)
end
c99162753.spchecks=aux.CreateChecks(Card.IsType,{TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK})
function c99162753.rmfilter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) and c:IsAbleToRemove()
end
function c99162753.fgoal(g,e,tp)
	if g:GetClassCount(Card.GetOriginalRace)~=1 then return false end
	return Duel.IsExistingMatchingCard(c99162753.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c99162753.spfilter(c,e,tp,g)
	return g:IsExists(aux.FilterEqualFunction(Card.GetOriginalRace,c:GetOriginalRace()),1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,g)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0)
end
function c99162753.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c99162753.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroupEach(c99162753.spchecks,c99162753.fgoal,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,6,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c99162753.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99162753.rmfilter),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroupEach(tp,c99162753.spchecks,false,c99162753.fgoal,e,tp)
	if rg and rg:GetCount()==6 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c99162753.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,rg)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
