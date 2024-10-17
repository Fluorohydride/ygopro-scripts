--リターナブル瓶
---@param c Card
function c84404797.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,84404797)
	e1:SetCost(c84404797.cost)
	e1:SetTarget(c84404797.target)
	e1:SetOperation(c84404797.activate)
	c:RegisterEffect(e1)
end
function c84404797.filter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c84404797.thfilter,tp,LOCATION_GRAVE,0,1,c,c:GetOriginalCodeRule())
end
function c84404797.thfilter(c,code)
	return c:IsType(TYPE_TRAP) and not c:IsOriginalCodeRule(code) and c:IsAbleToHand()
end
function c84404797.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c84404797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c84404797.filter,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c84404797.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(0,g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c84404797.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84404797.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
