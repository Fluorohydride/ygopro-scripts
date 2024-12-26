--水陸両用バグロス Mk－11
---@param c Card
function c4754691.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4754691.condition)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetCondition(c4754691.condition)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4754691,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,4754691)
	e3:SetCondition(c4754691.descon)
	e3:SetTarget(c4754691.destg)
	e3:SetOperation(c4754691.desop)
	c:RegisterEffect(e3)
end
function c4754691.condition(e)
	return not Duel.IsEnvironment(22702055)
end
function c4754691.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22702055)
end
function c4754691.desfilter(c)
	return c:IsFaceup() and c:IsNonAttribute(ATTRIBUTE_WATER)
end
function c4754691.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4754691.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4754691.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4754691.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4754691.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
