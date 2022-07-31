--不朽の特殊合金
function c37042505.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c37042505.condition1)
	e1:SetCost(c37042505.target)
	e1:SetOperation(c37042505.activate)
	c:RegisterEffect(e1)
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
function c37042505.filter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE)
end
function c37042505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCurrentChain()
	local b1=Duel.IsExistingMatchingCard(c37042505.filter1,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then
		if ct<1 and not b1 then return false end
		local te,tg=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		local b2=te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
			and tg and tg:IsExists(c37042505.filter2,1,nil,tp) and Duel.IsChainDisablable(ct)
		return b1 or b2
	end
	local te,tg=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	local b2=te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and tg and tg:IsExists(c37042505.filter2,1,nil,tp) and Duel.IsChainDisablable(ct-1)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(37042505,0),aux.Stringid(37042505,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(37042505,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(37042505,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,te:GetHandler(),1,0,0)
	end
end
function c37042505.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
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
	else
		Duel.NegateEffect(Duel.GetCurrentChain()-1)
	end
end
function c37042505.indoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
