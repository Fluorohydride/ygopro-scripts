--Sin パラレルギア
function c74509280.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c74509280.synlimit)
	e1:SetTargetRange(1,1)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
end
function c74509280.synlimit(e,c)
	return c:IsSetCard(0x23)
end
