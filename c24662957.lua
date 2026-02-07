--デモンズ・ゴーレム
function c24662957.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c24662957.target)
	e1:SetOperation(c24662957.activate)
	c:RegisterEffect(e1)
end
function c24662957.rmfilter(c)
	return c:IsAttackAbove(2000) and c:IsFaceup() and c:IsAbleToRemove()
end
function c24662957.cfilter(c)
	return (c:IsCode(70902743) or (aux.IsCodeListed(c,70902743) and c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_MZONE)))
		and c:IsFaceup()
end
function c24662957.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24662957.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24662957.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c24662957.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local ct=Duel.GetMatchingGroupCount(c24662957.cfilter,tp,LOCATION_ONFIELD,0,nil)
	e:SetLabel(ct)
end
function c24662957.stfilter(c)
	return c:IsCode(50078509) and c:IsSSetable()
end
function c24662957.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(24662957,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c24662957.retcon)
		e1:SetOperation(c24662957.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24662957.stfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if e:GetLabel()>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24662957,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sc)
		end
	end
end
function c24662957.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(24662957)~=0
end
function c24662957.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
