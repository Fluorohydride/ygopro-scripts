--ダーク・シティ
function c53527835.initial_effect(c)
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
	e2:SetCondition(c53527835.atkcon)
	e2:SetTarget(c53527835.atktg)
	e2:SetValue(c53527835.atkval)
	c:RegisterEffect(e2)
end
function c53527835.atkcon(e)
	c53527835[0]=false
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c53527835.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0xc008)
end
function c53527835.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c53527835[0] or c:GetAttack()<d:GetAttack() then
		c53527835[0]=true
		return 1000
	else return 0 end
end
