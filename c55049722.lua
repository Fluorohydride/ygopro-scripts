--S－Force チェイス
---@param c Card
function c55049722.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,55049722)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c55049722.target)
	e1:SetOperation(c55049722.activate)
	c:RegisterEffect(e1)
	--banish replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(55049722)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,55049723)
	c:RegisterEffect(e2)
end
function c55049722.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156)
end
function c55049722.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c55049722.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c55049722.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c55049722.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c55049722.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c55049722.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectTarget(tp,c55049722.thfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c55049722.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
