--シンクロ・ヒーロー
function c98143165.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c98143165.filter)
	--atk&lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98143165.filter(c)
	return c:GetLevel()>0
end
