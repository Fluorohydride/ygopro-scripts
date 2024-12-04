--W－ウィング・カタパルト
function c96300057.initial_effect(c)
	aux.EnableUnionAttribute(c,c96300057.filter)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(400)
	c:RegisterEffect(e4)
end
function c96300057.filter(c)
	return c:IsCode(51638941)
end
