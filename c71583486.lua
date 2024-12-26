--迷犬メリー
---@param c Card
function c71583486.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71583486,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,71583486)
	e1:SetTarget(c71583486.target)
	e1:SetOperation(c71583486.operation)
	c:RegisterEffect(e1)
end
function c71583486.thfilter(c)
	return c:IsCode(11548522) and c:IsAbleToHand()
end
function c71583486.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToDeck()
	local b2=Duel.IsExistingMatchingCard(c71583486.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToDeck()
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(71583486,1),aux.Stringid(71583486,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(71583486,1))
	else op=Duel.SelectOption(tp,aux.Stringid(71583486,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c71583486.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c71583486.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
