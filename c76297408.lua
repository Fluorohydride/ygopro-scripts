--魂粉砕
---@param c Card
function c76297408.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76297408,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c76297408.condition)
	e2:SetCost(c76297408.cost)
	e2:SetTarget(c76297408.target)
	e2:SetOperation(c76297408.operation)
	c:RegisterEffect(e2)
end
function c76297408.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c76297408.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c76297408.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76297408.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c76297408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c76297408.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c76297408.rfilter,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingTarget(c76297408.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c76297408.rfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(1-tp,c76297408.rfilter,1-tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),PLAYER_ALL,LOCATION_GRAVE)
end
function c76297408.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
