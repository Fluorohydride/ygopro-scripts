--coded by Lyris
--Chorus in the Sky
function c100312022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100312022+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCost(c100312022.cost)
	e1:SetTarget(c100312022.target)
	e1:SetOperation(c100312022.activate)
	c:RegisterEffect(e1)
end
function c100312022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100312022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsRace(RACE_FAIRY) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(aux.AND(Card.IsRace,Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,nil,RACE_FAIRY) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,Duel.SelectTarget(tp,aux.AND(Card.IsRace,Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,1,nil,RACE_FAIRY),1,0,0)
end
function c100312022.filter(c)
	return c:IsFaceup() and (c:IsCode(56433456) or aux.IsCodeListed(c,56433456)) and c:IsAbleToHand()
end
function c100312022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	local g=Duel.GetMatchingGroup(c100312022.filter,tp,LOCATION_REMOVED,0,nil)
	if (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,56433456) or Duel.IsEnvironment(56433456)) and #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
