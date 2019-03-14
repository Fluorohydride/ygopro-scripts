--魔力統轄
function c38943357.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,38943357+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c38943357.target)
	e1:SetOperation(c38943357.operation)
	c:RegisterEffect(e1)
end
function c38943357.filter(c)
	return c:IsSetCard(0x12a) and c:IsAbleToHand()
end
function c38943357.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38943357.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c38943357.cfilter(c)
	return c:IsCode(38943357,75014062) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c38943357.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c38943357.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.GetMatchingGroupCount(c38943357.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)>0
			and Duel.SelectYesNo(tp,aux.Stringid(38943357,0)) then
			while ct>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,nil,0x1,1):GetFirst()
				if not tc then break end
				tc:AddCounter(0x1,1)
				ct=ct-1
			end
		end
	end
end
