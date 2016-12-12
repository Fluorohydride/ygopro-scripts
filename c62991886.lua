--進化する人類
function c62991886.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(c62991886.condition)
	e2:SetValue(c62991886.value)
	c:RegisterEffect(e2)
end
function c62991886.condition(e)
	return Duel.GetLP(0)~=Duel.GetLP(1)
end
function c62991886.value(e,c)
	local p=e:GetHandler():GetControler()
	if Duel.GetLP(p)<Duel.GetLP(1-p) then
		return 2400
	elseif Duel.GetLP(p)>Duel.GetLP(1-p) then
		return 1000
	end
end
