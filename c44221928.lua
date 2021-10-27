--褒誉の息吹
function c44221928.initial_effect(c)
	local e0=aux.AddRitualProcEqual2(c,c44221928.ritual_filter)
	c:RegisterEffect(e0)
end
function c44221928.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WIND)
end
