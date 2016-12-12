--甲虫装機の魔弓 ゼクトアロー
function c87047074.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x56))
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--chain limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c87047074.chcon)
	e4:SetOperation(c87047074.chop)
	c:RegisterEffect(e4)
end
function c87047074.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler():GetEquipTarget()
end
function c87047074.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c87047074.chlimit)
end
function c87047074.chlimit(e,ep,tp)
	return ep==tp
end
