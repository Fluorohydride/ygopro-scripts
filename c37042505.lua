--不朽の特殊合金
---@param c Card
function c37042505.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37042505,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c37042505.condition1)
	e1:SetCost(c37042505.target1)
	e1:SetOperation(c37042505.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37042505,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c37042505.condition2)
	e2:SetTarget(c37042505.target2)
	e2:SetOperation(c37042505.activate2)
	c:RegisterEffect(e2)
end
function c37042505.cfilter(c)
	return c:IsCode(77585513) and c:IsFaceup()
end
function c37042505.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37042505.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c37042505.filter1(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c37042505.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37042505.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c37042505.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37042505.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c37042505.indoval)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c37042505.indoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c37042505.filter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE)
end
function c37042505.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not c37042505.condition1(e,tp,eg,ep,ev,re,r,rp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and Duel.IsChainDisablable(ev) and tg:IsExists(c37042505.filter2,1,nil,tp)
end
function c37042505.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c37042505.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
