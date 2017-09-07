--マーメイド・ナイト
function c24435369.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(c24435369.dircon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c24435369.dircon(e)
	return Duel.IsEnvironment(22702055)
end
