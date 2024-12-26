--ドロゴン・ベビー
---@param c Card
function c40380686.initial_effect(c)
	--non tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c40380686.tnval)
	c:RegisterEffect(e1)
	--change race or attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c40380686.condition)
	e2:SetTarget(c40380686.target)
	e2:SetOperation(c40380686.operation)
	c:RegisterEffect(e2)
end
function c40380686.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c40380686.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c40380686.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c40380686.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40380686.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40380686.filter,tp,LOCATION_MZONE,0,1,nil) end
	local ar=0
	local op=Duel.SelectOption(tp,aux.Stringid(40380686,0),aux.Stringid(40380686,1))
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		ar=Duel.AnnounceRace(tp,1,RACE_ALL)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		ar=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	end
	e:SetLabel(op,ar)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40380686.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40380686.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local c,op,ar=e:GetHandler(),e:GetLabel()
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(ar)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ar)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
