--右手に盾を左手に剣を
---@param c Card
function c52097679.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c52097679.target)
	e1:SetOperation(c52097679.activate)
	c:RegisterEffect(e1)
end
function c52097679.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c52097679.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingMatchingCard(c52097679.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c52097679.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetTargetCard(g)
end
function c52097679.efilter(c,e)
	return c52097679.filter(c) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c52097679.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c52097679.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local batk=tc:GetBaseAttack()
		local bdef=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(bdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		e2:SetValue(batk)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end
