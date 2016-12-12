--火器付機甲鎧
function c3492538.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c3492538.filter)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(700)
	c:RegisterEffect(e2)
end
function c3492538.filter(c)
	return c:IsRace(RACE_INSECT)
end
