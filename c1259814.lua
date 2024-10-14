--千六百七十七万工房
---@param c Card
function c1259814.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1259814,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1259814.tg)
	e1:SetOperation(c1259814.op)
	c:RegisterEffect(e1)
end
function c1259814.filter(c)
	if not c:IsFaceup() then return false end
	if not c:IsRace(RACE_MACHINE) then return true end
	local ct=0
	local attr=1
	for i=1,7 do
		if c:IsAttribute(attr) then ct=ct+1 end
		attr=attr<<1
	end
	return ct<6
end
function c1259814.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1259814.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1259814.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1259814.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c1259814.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_MACHINE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
