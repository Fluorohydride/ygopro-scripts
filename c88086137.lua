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
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return false end
		col=aux.SZoneSequence(seq)
	else
		return false
	end
	if p==1-tp then col=4-col end
	return aux.GetColumn(c,tp)==col	and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
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
