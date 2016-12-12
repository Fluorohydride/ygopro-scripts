--レアゴールド・アーマー
function c7625614.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atk target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c7625614.atkcon)
	e2:SetValue(c7625614.atktg)
	c:RegisterEffect(e2)
end
function c7625614.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetControler()==e:GetHandlerPlayer()
end
function c7625614.atktg(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
