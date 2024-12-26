--世壊輪廻
---@param c Card
function c2116237.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2116237,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,2116237)
	e1:SetCost(c2116237.cost)
	e1:SetTarget(c2116237.target)
	e1:SetOperation(c2116237.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2116237,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,2116238)
	e2:SetCondition(c2116237.thcon)
	e2:SetTarget(c2116237.thtg)
	e2:SetOperation(c2116237.thop)
	c:RegisterEffect(e2)
end
function c2116237.costfilter(c,e,tp)
	return c:IsCode(56099748) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c2116237.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c2116237.spfilter(c,e,tp,sc)
	return c:IsSetCard(0x1a0) and c:IsAttack(3000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c2116237.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c2116237.costfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c2116237.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	if Duel.Remove(g,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local rc=g:GetFirst()
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(2116237,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c2116237.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c2116237.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c2116237.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() or Duel.IsExistingMatchingCard(c2116237.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2116237.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c2116237.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(2116237,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(2116237,3))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c2116237.rmcon)
		e1:SetOperation(c2116237.rmop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(c2116237.aclimit)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCondition(c2116237.econ)
		e3:SetValue(c2116237.elimit)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end
function c2116237.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(2116237)==e:GetLabel()
end
function c2116237.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
function c2116237.aclimit(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()~=e:GetHandler() then return end
	e:GetHandler():RegisterFlagEffect(2116238,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c2116237.econ(e)
	return e:GetHandler():GetFlagEffect(2116238)~=0
end
function c2116237.elimit(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c2116237.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c2116237.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2116237.cfilter,1,nil,tp)
end
function c2116237.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c2116237.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
