--聖なる煌炎
function c58374502.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58374502,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,58374502+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c58374502.condition)
	e1:SetCost(c58374502.cost)
	e1:SetTarget(c58374502.target)
	e1:SetOperation(c58374502.activate)
	c:RegisterEffect(e1)
end
function c58374502.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainDisablable(ev)
end
function c58374502.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(7) and c:IsRace(RACE_DRAGON)
		and c:IsAbleToHandAsCost()
end
function c58374502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58374502.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c58374502.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c58374502.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c58374502.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
