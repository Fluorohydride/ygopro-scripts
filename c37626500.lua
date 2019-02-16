--精霊の祝福
function c37626500.initial_effect(c)
	aux.AddRitualProcEqual2(c,c37626500.ritual_filter)
end
function c37626500.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
