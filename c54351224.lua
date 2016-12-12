--リチュアル・ウェポン
function c54351224.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c54351224.filter)
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
function c54351224.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelBelow(6)
end
