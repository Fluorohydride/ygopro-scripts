--霊魂の降神
function c73055622.initial_effect(c)
	aux.AddRitualProcUltimate(c,c73055622.filter,Card.GetLevel,"Greater",nil,c73055622.mfilter)
end
c73055622.fit_monster={25415052,52900000}
function c73055622.filter(c)
	return c:IsCode(25415052,52900000)
end
function c73055622.mfilter(c)
	return c:IsType(TYPE_SPIRIT)
end
