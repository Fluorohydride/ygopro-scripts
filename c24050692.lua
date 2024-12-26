--溟界の蛇睡蓮
---@param c Card
function c24050692.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24050692+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c24050692.target)
	e1:SetOperation(c24050692.activate)
	c:RegisterEffect(e1)
end
function c24050692.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
end
function c24050692.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24050692.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c24050692.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE)
end
function c24050692.spfilter(c,e,tp)
	return c24050692.cfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24050692.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24050692.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0
		and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroup(c24050692.cfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=5
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c24050692.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(24050692,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24050692.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
