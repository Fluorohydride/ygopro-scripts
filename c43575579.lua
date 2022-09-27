--アフター・グロー
function c43575579.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,43575579+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43575579.target)
	e1:SetOperation(c43575579.operation)
	c:RegisterEffect(e1)
end
function c43575579.rmfilter(c)
	return c:IsCode(43575579) and c:IsAbleToRemove() and (c:IsFaceup() or not c:IsOnField())
end
function c43575579.tdfilter(c)
	return c:IsCode(43575579) and c:IsAbleToDeck() and c:IsFaceup()
end
function c43575579.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c43575579.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	g:AddCard(e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c43575579.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c43575579.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c43575579.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c43575579.damcon)
	e1:SetOperation(c43575579.damop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c43575579.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetOwnerPlayer() and r==REASON_RULE
end
function c43575579.damop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(Card.IsCode,nil,43575579)
	if dg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,43575579)
		Duel.Damage(1-ep,4000,REASON_EFFECT)
	end
	Duel.ShuffleHand(ep)
end
