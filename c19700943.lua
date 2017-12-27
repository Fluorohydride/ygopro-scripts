--ドドドボット
function c19700943.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c19700943.sumcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c19700943.immcon)
	e2:SetValue(c19700943.efilter)
	c:RegisterEffect(e2)
end
function c19700943.sumcon(e,c,minc)
	if not c then return true end
	return false
end
function c19700943.immcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c19700943.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
