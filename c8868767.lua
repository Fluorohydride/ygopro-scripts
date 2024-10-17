--ダイスエット
---@param c Card
function c8868767.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c8868767.target)
	e1:SetOperation(c8868767.activate)
	c:RegisterEffect(e1)
end
c8868767.toss_dice=true
function c8868767.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetTurnPlayer()==tp then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
	else
		if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	end
end
function c8868767.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,d,d,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		if d==1 then
			Duel.DiscardDeck(tp,6,REASON_EFFECT)
		end
	else
		Duel.DiscardDeck(tp,d,REASON_EFFECT)
		if d==6 then
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
