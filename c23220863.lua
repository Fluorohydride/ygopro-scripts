--シュルブの魔導騎兵
function c23220863.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c23220863.efilter)
	c:RegisterEffect(e1)
end
function c23220863.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and not te:GetOwner():IsType(TYPE_PENDULUM)
end
