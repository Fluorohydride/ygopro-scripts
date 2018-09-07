--蟲惑の落とし穴
function c29616929.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c29616929.condition)
	e1:SetTarget(c29616929.target)
	e1:SetOperation(c29616929.activate)
	c:RegisterEffect(e1)
end
function c29616929.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and loc==LOCATION_MZONE and tc:IsStatus(STATUS_SPSUMMON_TURN) and Duel.IsChainDisablable(ev)
end
function c29616929.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c29616929.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
