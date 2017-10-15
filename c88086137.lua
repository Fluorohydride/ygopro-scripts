--直通断線
function c88086137.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c88086137.condition)
	e1:SetTarget(c88086137.target)
	e1:SetOperation(c88086137.activate)
	c:RegisterEffect(e1)
end
function c88086137.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if p==1-tp then seq=seq+16 end
	local zone=bit.lshift(1,seq)
	return (bit.band(c:GetColumnZone(LOCATION_MZONE),zone)~=0 or bit.band(c:GetColumnZone(LOCATION_SZONE),zone)~=0)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c88086137.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c88086137.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
