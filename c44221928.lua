--褒誉の息吹
---@param c Card
function c44221928.initial_effect(c)
	aux.AddRitualProcEqual2(c,c44221928.ritual_filter)
end
function c44221928.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WIND)
end
