--精霊の祝福
function c37626500.initial_effect(c)
	local e0=aux.AddRitualProcEqual2(c,c37626500.ritual_filter)
	c:RegisterEffect(e0)
end
function c37626500.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
