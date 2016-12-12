--巨大化
function c22046459.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(c22046459.condition)
	e2:SetValue(c22046459.value)
	c:RegisterEffect(e2)
end
function c22046459.condition(e)
	return Duel.GetLP(0)~=Duel.GetLP(1)
end
function c22046459.value(e,c)
	local p=e:GetHandler():GetControler()
	if Duel.GetLP(p)<Duel.GetLP(1-p) then
		return c:GetBaseAttack()*2
	elseif Duel.GetLP(p)>Duel.GetLP(1-p) then
		return c:GetBaseAttack()/2
	end
end
