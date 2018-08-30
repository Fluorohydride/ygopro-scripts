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
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end
function c53527835.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c53527835.atktg(e,c)
	if c~=Duel.GetAttacker() or not c:IsSetCard(0xc008) then return false end
	local d=Duel.GetAttackTarget()
	if c:GetFlagEffect(53527835)>0 or c:GetAttack()<d:GetAttack() then
		c:RegisterFlagEffect(53527835,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
		return true
	else return false end
end
