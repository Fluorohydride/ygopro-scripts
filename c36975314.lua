--大捕り物
function c36975314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c36975314.target)
	e1:SetOperation(c36975314.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c36975314.descon)
	e2:SetOperation(c36975314.desop)
	c:RegisterEffect(e2)
end
function c36975314.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c36975314.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c36975314.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c36975314.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c36975314.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c36975314.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(c36975314.ctval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(e)
		e1:SetCondition(c36975314.con)
		tc:RegisterEffect(e1,true)
		--cannot attack, trigger
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.ctg)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		c:RegisterEffect(e3)
	end
end
function c36975314.con(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	local te=e:GetLabelObject()
	return c:IsHasCardTarget(h) and not h:IsImmuneToEffect(te)
end
function c36975314.ctval(e,c)
	return e:GetOwnerPlayer()
end
function c36975314.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c36975314.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
