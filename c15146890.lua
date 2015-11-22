--竜脈の魔術師
function c15146890.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15146890,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c15146890.condition)
	e1:SetCost(c15146890.cost)
	e1:SetTarget(c15146890.target)
	e1:SetOperation(c15146890.operation)
	c:RegisterEffect(e1)
end
function c15146890.condition(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x98)
end
function c15146890.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsDiscardable()
end
function c15146890.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15146890.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c15146890.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c15146890.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c15146890.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c15146890.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15146890.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15146890.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c15146890.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
