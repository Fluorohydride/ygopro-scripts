--城壁壊しの大槍
function c242146.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c242146.atkcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
end
function c242146.atkcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local eqc=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a==eqc and d:GetBattlePosition()==POS_FACEDOWN_DEFENSE
end
