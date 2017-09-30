--極星霊スヴァルトアールヴ
function c73417207.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c73417207.synlimit)
	e1:SetTargetRange(2,2)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
end
function c73417207.synlimit(e,c)
	return c:IsSetCard(0x42)
end
