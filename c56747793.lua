--団結の力
function c56747793.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c56747793.value)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c56747793.value)
	c:RegisterEffect(e3)
end
function c56747793.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*800
end
