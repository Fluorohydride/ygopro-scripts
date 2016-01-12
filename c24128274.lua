--深海の戦士
--Deepsea Warrior
function c24128274.initial_effect(c)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c24128274.econ)
	e1:SetValue(c24128274.efilter)
	c:RegisterEffect(e1)
end
function c24128274.filter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c24128274.econ(e)
	return Duel.IsExistingMatchingCard(c24128274.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c24128274.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
