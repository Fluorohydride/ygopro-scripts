--摩天楼 －スカイスクレイパー－
function c63035430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c63035430.atkcon)
	e2:SetTarget(c63035430.atktg)
	e2:SetValue(c63035430.atkval)
	c:RegisterEffect(e2)
end
function c63035430.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c63035430.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0x3008)
end
function c63035430.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetFlagEffect(63035430)~=0 then return 1000 end
	if c:GetAttack()<d:GetAttack() then
		c:RegisterFlagEffect(63035430,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
		return 1000
	else return 0 end
end
