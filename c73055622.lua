--霊魂の降神
function c73055622.initial_effect(c)
	local e0=aux.AddRitualProcGreater2Code2(c,25415052,52900000,nil,c73055622.mfilter)
	c:RegisterEffect(e0)
end
function c73055622.mfilter(c)
	return c:IsType(TYPE_SPIRIT)
end
