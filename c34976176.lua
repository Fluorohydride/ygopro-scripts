--BF－雪撃のチヌーク
function c34976176.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34976176,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,34976176)
	e1:SetCondition(c34976176.discon1)
	e1:SetCost(c34976176.discost)
	e1:SetTarget(c34976176.distg)
	e1:SetOperation(c34976176.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c34976176.discon2)
	c:RegisterEffect(e2)
end
function c34976176.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c34976176.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c34976176.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c34976176.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c34976176.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c34976176.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c34976176.filter(c)
	return c:IsFaceup() and (aux.NegateMonsterFilter(c) or c:GetAttack()>0)
end
function c34976176.tgfilter(c)
	return c:IsAbleToGrave() and ((c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)) or c:IsCode(9012916))
end
function c34976176.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c34976176.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c34976176.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c34976176.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c34976176.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c34976176.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c34976176.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(-700)
		tc:RegisterEffect(e3)
	end
end
