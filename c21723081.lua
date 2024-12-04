--X・Y・Zハイパーキャノン
function c21723081.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21723081,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,21723081)
	e2:SetCondition(c21723081.condition)
	e2:SetTarget(c21723081.target)
	e2:SetOperation(c21723081.operation)
	c:RegisterEffect(e2)
end
c21723081.has_text_type=TYPE_UNION
function c21723081.cfilter(c)
	return c:IsFaceup() and (c:IsCode(91998119) or c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,91998119))
end
function c21723081.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21723081.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21723081.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_UNION) and c:IsAbleToDeck()
end
function c21723081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.GetTurnPlayer()==tp then
		if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c21723081.tdfilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c21723081.tdfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			and Duel.IsPlayerCanDraw(tp,1) end
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c21723081.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
		e:SetCategory(CATEGORY_DESTROY)
		local rt=Duel.GetTargetCount(nil,tp,0,LOCATION_ONFIELD,nil)
		local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,rt,REASON_COST+REASON_DISCARD,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
	end
end
function c21723081.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
		if rg:GetCount()>0 then
			Duel.Destroy(rg,REASON_EFFECT)
		end
	end
end
