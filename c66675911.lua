--星なる影 ゲニウス
function c66675911.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66675911,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,66675911)
	e1:SetCost(c66675911.cost)
	e1:SetTarget(c66675911.target)
	e1:SetOperation(c66675911.operation)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66675911,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,66675911)
	e2:SetCost(c66675911.cost)
	e2:SetCondition(c66675911.actcon)
	e2:SetTarget(c66675911.acttg)
	e2:SetOperation(c66675911.actop)
	c:RegisterEffect(e2)
end
function c66675911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c66675911.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9d)
end
function c66675911.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66675911.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66675911.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c66675911.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66675911.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c66675911.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c66675911.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re:IsActiveType(TYPE_MONSTER)
end
function c66675911.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c66675911.actfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c66675911.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66675911.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66675911.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66675911.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66675911.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
