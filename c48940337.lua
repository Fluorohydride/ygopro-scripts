--ランスフォリンクス
function c48940337.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c48940337.target)
	c:RegisterEffect(e1)
end
function c48940337.target(e,c)
	return c:IsType(TYPE_NORMAL)
end
