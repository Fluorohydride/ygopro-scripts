--軍隊ピラニア
---@param c Card
function c50823978.initial_effect(c)
	--deepen damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetCondition(c50823978.dcon)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
end
function c50823978.dcon(e)
	return Duel.GetAttackTarget()==nil
end
