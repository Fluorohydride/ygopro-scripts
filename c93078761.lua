--賽挑戦
---@param c Card
function c93078761.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,93078761+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c93078761.target)
	e1:SetOperation(c93078761.activate)
	c:RegisterEffect(e1)
end
function c93078761.filter(c)
	return c:IsEffectProperty(aux.EffectCategoryFilter(CATEGORY_DICE)) and c:IsAbleToHand()
end
function c93078761.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93078761.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c93078761.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dice1=Duel.TossDice(tp,1)
	if (dice1==1 or dice1==6) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c93078761.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		return
	elseif c:IsRelateToEffect(e) then
		local dice2=Duel.TossDice(tp,1)
		if (dice2==1 or dice2==6) then
			c:CancelToGrave()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		elseif dice2>=2 and dice2<=5 then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
