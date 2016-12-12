--光学迷彩アーマー
function c44762290.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterEqualFunction(Card.GetLevel,1))
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
