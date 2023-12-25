--武装再生
function c32549749.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32549749+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32549749.target)
	e1:SetOperation(c32549749.activate)
	c:RegisterEffect(e1)
end
function c32549749.filter(c,tp)
	if not c:IsType(TYPE_EQUIP) then return false end
	return c:IsSSetable(true)
		or Duel.IsExistingMatchingCard(c32549749.eqfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c32549749.eqfilter(c,ec,tp)
	if c:IsFacedown() then return false end
	return not ec:IsForbidden() and ec:CheckUniqueOnField(tp) and ec:CheckEquipTarget(c)
end
function c32549749.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup()
		else
			return chkc:IsLocation(LOCATION_GRAVE) and c32549749.filter(chkc,tp)
		end
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	local b1=aux.dscon(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.GetCurrentPhase()~=PHASE_DAMAGE and ft>0
		and Duel.IsExistingTarget(c32549749.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(32549749,0),aux.Stringid(32549749,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(32549749,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(32549749,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil,tp)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c32549749.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c32549749.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	else
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local b1=tc:IsSSetable(true) and ft>0
		local b2=Duel.IsExistingMatchingCard(c32549749.eqfilter,tp,LOCATION_MZONE,0,1,nil,tc,tp)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(32549749,2),aux.Stringid(32549749,3))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(32549749,2))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(32549749,3))+1
		else
			return
		end
		if op==0 then
			Duel.SSet(tp,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tgc=Duel.SelectMatchingCard(tp,c32549749.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc,tp):GetFirst()
			if not tgc then return end
			Duel.Equip(tp,tc,tgc)
		end
	end
end
