--S－Force オリフィス
---@param c Card
function c95974848.initial_effect(c)
	--can not be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c95974848.ettg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95974848,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95974848)
	e2:SetCondition(c95974848.descon)
	e2:SetCost(c95974848.descost)
	e2:SetTarget(c95974848.destg)
	e2:SetOperation(c95974848.desop)
	c:RegisterEffect(e2)
end
function c95974848.etfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c95974848.ettg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c95974848.etfilter,1,nil,e:GetHandlerPlayer())
end
function c95974848.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c95974848.costfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsSetCard(0x156) and c:IsAbleToRemoveAsCost()
	else
		return e:GetHandler():IsSetCard(0x156) and c:IsHasEffect(55049722,tp) and c:IsAbleToRemoveAsCost()
	end
end
function c95974848.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95974848.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c95974848.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(55049722,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
	else
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	end
end
function c95974848.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c95974848.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
