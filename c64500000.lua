--Z－メタル・キャタピラー
function c64500000.initial_effect(c)
	aux.EnableUnionAttribute(c,c64500000.filter)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	c:RegisterEffect(e3)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(600)
	c:RegisterEffect(e4)
end
function c64500000.filter(c)
	return c:IsCode(62651957,65622692)
end
