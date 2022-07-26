--謙虚な瓶
function c22454453.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c22454453.target)
	e1:SetOperation(c22454453.activate)
	c:RegisterEffect(e1)
end
function c22454453.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c22454453.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		else
			local opt=Duel.SelectOption(tp,aux.Stringid(22454453,0),aux.Stringid(22454453,1))
			if opt==0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
			else
				Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end
