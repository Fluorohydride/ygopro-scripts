--孤高の格闘家
---@param c Card
function c82452993.initial_effect(c)
	aux.AddCodeList(c,8508055,3810071,49814180)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c82452993.target)
	e1:SetOperation(c82452993.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TARGET)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c82452993.efilter)
	c:RegisterEffect(e3)
end
function c82452993.filter(c)
	return c:IsFaceup() and c:IsCode(8508055,3810071,49814180)
end
function c82452993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return g:GetCount()==1 and c82452993.filter(g:GetFirst()) end
	Duel.SetTargetCard(g)
end
function c82452993.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c82452993.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
