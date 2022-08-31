--モノ・シンクロン
function c56897896.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c56897896.synlimit)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(56897896)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
end
function c56897896.synlimit(e,c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR+RACE_MACHINE)
end
