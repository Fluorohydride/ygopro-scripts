--召喚獣メルカバー
---@param c Card
function c75286621.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),1,true,true)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75286621,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c75286621.negcon)
	e1:SetCost(c75286621.negcost)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c75286621.negop)
	c:RegisterEffect(e1)
end
function c75286621.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c75286621.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGraveAsCost()
end
function c75286621.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c75286621.cfilter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.DiscardHand(tp,c75286621.cfilter,1,1,REASON_COST,nil,rtype)
end
function c75286621.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
