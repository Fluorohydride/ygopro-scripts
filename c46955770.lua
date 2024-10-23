--墓守の異端者
function c46955770.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c46955770.con)
	e1:SetValue(c46955770.efilter)
	c:RegisterEffect(e1)
end
function c46955770.con(e)
	return Duel.IsEnvironment(47355498)
end
function c46955770.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
