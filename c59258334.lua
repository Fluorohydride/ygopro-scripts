--洗脳光線
---@param c Card
function c59258334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c59258334.target)
	e1:SetOperation(c59258334.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c59258334.descon)
	c:RegisterEffect(e2)
	--destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c59258334.descon2)
	e3:SetOperation(c59258334.desop2)
	c:RegisterEffect(e3)
	--remove counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c59258334.rccon)
	e4:SetOperation(c59258334.rcop)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TARGET)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c59258334.cttg)
	e5:SetValue(c59258334.ctval)
	c:RegisterEffect(e5)
end
function c59258334.filter(c)
	return c:GetCounter(0x100e)>0 and c:IsControlerCanBeChanged()
end
function c59258334.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c59258334.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59258334.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c59258334.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c59258334.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:GetCounter(0x100e)>0 and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c59258334.cttg(e,c)
	return c:GetCounter(0x100e)>0
end
function c59258334.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c59258334.descon(e)
	local c=e:GetHandler()
	if c:GetCardTargetCount()==0 then return false end
	return c:GetFirstCardTarget():GetCounter(0x100e)==0
end
function c59258334.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c59258334.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c59258334.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFirstCardTarget()
end
function c59258334.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	tc:RemoveCounter(tp,0x100e,1,REASON_EFFECT)
	Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x100e,e,REASON_EFFECT,tp,tp,1)
end
