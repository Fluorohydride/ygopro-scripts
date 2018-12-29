--金魚救い
function c9251497.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand & todeck or to GY & selfdestroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9251497)
	e2:SetTarget(c9251497.target)
	e2:SetOperation(c9251497.operation)
	c:RegisterEffect(e2)
end
function c9251497.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_GRAVE,1,nil,TYPE_MONSTER)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
end
function c9251497.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetDecktopGroup(tp,1)
	if tc:IsRelateToEffect(e) then
		if g:GetFirst():GetAttribute()&tc:GetAttribute()~=0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		else
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
