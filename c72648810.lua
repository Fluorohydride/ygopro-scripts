--揺るがぬ絆
function c72648810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c72648810.condition)
	e1:SetTarget(c72648810.target)
	e1:SetOperation(c72648810.activate)
	c:RegisterEffect(e1)
end
function c72648810.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local atype=re:GetActiveType()
	return rp==1-tp and (bit.band(atype,TYPE_PENDULUM+TYPE_MONSTER)==TYPE_PENDULUM+TYPE_MONSTER
		or (atype==TYPE_PENDULUM+TYPE_SPELL and bit.band(loc,LOCATION_PZONE)~=0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
		and Duel.IsChainNegatable(ev)
end
function c72648810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove()  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c72648810.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
