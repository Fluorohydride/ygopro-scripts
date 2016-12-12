--最強の盾
function c84877802.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c84877802.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c84877802.defval)
	c:RegisterEffect(e3)
end
function c84877802.atkval(e,c)
	if c:IsDefensePos() then return 0 else return c:GetBaseDefense() end
end
function c84877802.defval(e,c)
	if c:IsAttackPos() then return 0 else return c:GetBaseAttack() end
end
