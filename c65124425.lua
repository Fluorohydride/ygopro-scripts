--虚ろなる龍輪
function c65124425.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65124425+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65124425.target)
	e1:SetOperation(c65124425.activate)
	c:RegisterEffect(e1)
end
function c65124425.tgfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGrave()
end
function c65124425.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65124425.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65124425.thcfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c65124425.thfilter(c,tc)
	return c:IsSetCard(0x12c) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function c65124425.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c65124425.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c65124425.thcfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c65124425.thfilter,tp,LOCATION_DECK,0,1,nil,tc)
		and Duel.SelectYesNo(tp,aux.Stringid(65124425,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65124425.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
