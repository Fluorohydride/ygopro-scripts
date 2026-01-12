--無許可の再奇動
function c12524259.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,12524259+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12524259.target)
	e1:SetOperation(c12524259.activate)
	c:RegisterEffect(e1)
end
c12524259.has_text_type=TYPE_UNION
function c12524259.tgfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c12524259.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,tp)
end
function c12524259.eqfilter(c,tc,tp)
	return aux.CheckUnionEquip(c,tc) and c:CheckUnionTarget(tc) and c:IsType(TYPE_UNION)
		and c:IsRace(RACE_MACHINE) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c12524259.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsLocation(LOCATION_SZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if b then ft=ft-1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12524259.tgfilter(chkc,tp) end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c12524259.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c12524259.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c12524259.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c12524259.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc,tp)
		local ec=g:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ec:RegisterEffect(e1)
		end
	end
end
