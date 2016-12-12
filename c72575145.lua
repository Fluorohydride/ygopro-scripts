--降格処分
function c72575145.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c72575145.filter)
	--lvl
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetValue(-2)
	c:RegisterEffect(e2)
end
function c72575145.filter(c)
	return c:GetLevel()>0
end
