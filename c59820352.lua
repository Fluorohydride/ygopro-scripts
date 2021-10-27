--大地讃頌
function c59820352.initial_effect(c)
	local e0=aux.AddRitualProcEqual2(c,c59820352.ritual_filter)
	c:RegisterEffect(e0)
end
function c59820352.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_EARTH)
end
