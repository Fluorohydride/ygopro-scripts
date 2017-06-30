--レッド・ロイド・コール
function c70628672.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c70628672.condition)
	e1:SetTarget(c70628672.target)
	e1:SetOperation(c70628672.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,70628672)
	e2:SetCost(c70628672.thcost)
	e2:SetTarget(c70628672.thtg)
	e2:SetOperation(c70628672.thop)
	c:RegisterEffect(e2)
end
function c70628672.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x16) and c:IsType(TYPE_FUSION)
end
function c70628672.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70628672.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c70628672.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,rp,LOCATION_DECK+LOCATION_EXTRA)
end
function c70628672.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local cd=re:GetHandler():GetCode()
		local g=Duel.GetMatchingGroup(Card.IsCode,rp,LOCATION_DECK+LOCATION_EXTRA,0,nil,cd)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c70628672.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c70628672.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x16) and c:IsAbleToHand()
end
function c70628672.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70628672.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70628672.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c70628672.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c70628672.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
