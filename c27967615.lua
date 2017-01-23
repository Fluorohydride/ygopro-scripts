--フュージョン・ウェポン
function c27967615.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c27967615.filter)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1500)
	c:RegisterEffect(e3)
end
function c27967615.filter(c)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(6)
end
