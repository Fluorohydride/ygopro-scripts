--エクソシスター・パークス
---@param c Card
function c77913594.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77913594,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77913594+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c77913594.condition)
	e1:SetCost(c77913594.cost)
	e1:SetTarget(c77913594.target)
	e1:SetOperation(c77913594.operation)
	c:RegisterEffect(e1)
end
function c77913594.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c77913594.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c77913594.thfilter(c)
	return c:IsSetCard(0x172) and not c:IsCode(77913594) and c:IsAbleToHand()
end
function c77913594.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77913594.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77913594.spfilter(c,sc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x172) and aux.IsCodeListed(sc,c:GetCode())
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c77913594.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c77913594.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local res=false
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		res=true
	end
	if res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77913594.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tc)
		and Duel.SelectYesNo(tp,aux.Stringid(77913594,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
