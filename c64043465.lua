--魔神火炎砲
function c64043465.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c64043465.target1)
	e1:SetOperation(c64043465.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64043465,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,64043465)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c64043465.cost)
	e2:SetTarget(c64043465.target2)
	e2:SetOperation(c64043465.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64043465,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,64043465)
	e3:SetCondition(c64043465.thcon)
	e3:SetCost(c64043465.cost)
	e3:SetTarget(c64043465.thtg)
	e3:SetOperation(c64043465.thop)
	c:RegisterEffect(e3)
end
function c64043465.tgfilter(c)
	return ((c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xde)) and c:IsAbleToGrave()
end
function c64043465.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return true end
	if Duel.GetFlagEffect(tp,64043465)==0 and Duel.IsExistingMatchingCard(c64043465.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.RegisterFlagEffect(tp,64043465,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		e:SetLabel(1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c64043465.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,64043465)==0 end
	Duel.RegisterFlagEffect(tp,64043465,RESET_PHASE+PHASE_END,0,1)
end
function c64043465.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(c64043465.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c64043465.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c64043465.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c64043465.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c64043465.thfilter(c)
	return ((c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xde)) and c:IsAbleToHand()
end
function c64043465.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c64043465.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c64043465.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c64043465.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c64043465.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
