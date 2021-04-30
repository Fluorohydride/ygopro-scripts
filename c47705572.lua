--月光狼
function c47705572.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47705572.splimit)
	c:RegisterEffect(e1)
	--fusion
	local e2=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0xdf),
		mat_location=LOCATION_MZONE+LOCATION_GRAVE,
		mat_filter=Card.IsAbleToRemove,
		mat_operation=aux.FMaterialRemove,
		reg=false
	})
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c47705572.ptg)
	c:RegisterEffect(e3)
end
function c47705572.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsSetCard(0xdf) and c:IsType(TYPE_MONSTER)) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47705572.ptg(e,c)
	return c:IsSetCard(0xdf) and c:IsType(TYPE_MONSTER)
end
