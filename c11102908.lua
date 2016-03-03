--紫炎の霞城
function c11102908.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c11102908.atkcon)
	e2:SetTarget(c11102908.atktg)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
end
function c11102908.atkcon(e)
	local d=Duel.GetAttackTarget()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and d and d:IsSetCard(0x3d)
end
function c11102908.atktg(e,c)
	return c==Duel.GetAttacker()
end
