--奈落との契約
function c69035382.initial_effect(c)
	local e0=aux.AddRitualProcEqual2(c,c69035382.ritual_filter)
	c:RegisterEffect(e0)
end
function c69035382.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_DARK)
end
