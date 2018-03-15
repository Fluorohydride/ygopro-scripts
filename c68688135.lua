--ヴァンパイアの支配
function c68688135.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,68688135+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c68688135.condition)
	e1:SetTarget(c68688135.target)
	e1:SetOperation(c68688135.activate)
	c:RegisterEffect(e1)
end
function c68688135.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8e)
end
function c68688135.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c68688135.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c68688135.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		if re:GetHandler():IsType(TYPE_MONSTER) then
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,re:GetHandler():GetBaseAttack())
		end
	end
end
function c68688135.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)~=0 and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,re:GetHandler():GetBaseAttack(),REASON_EFFECT)
	end
end
