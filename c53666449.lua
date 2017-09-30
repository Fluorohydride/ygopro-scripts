--天空賢者ミネルヴァ
function c53666449.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c53666449.atkcon)
	e1:SetOperation(c53666449.atkop)
	c:RegisterEffect(e1)
end
function c53666449.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_COUNTER)
end
function c53666449.thfilter(c,code)
	return c:IsType(TYPE_COUNTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c53666449.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local rc=re:GetHandler()
	if not rc then return end
	local code=rc:GetCode()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c53666449.thfilter),tp,LOCATION_GRAVE,0,nil,code)
	if Duel.IsEnvironment(56433456) and g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,53666449)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
