--水陸両用バグロス MK－3
function c64342551.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c64342551.dircon)
	c:RegisterEffect(e1)
end
function c64342551.dircon(e)
	return Duel.IsEnvironment(22702055)
end
