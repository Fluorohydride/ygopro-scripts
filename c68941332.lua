--六花の薄氷
function c68941332.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,68941332+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c68941332.cost)
	e1:SetTarget(c68941332.target)
	e1:SetOperation(c68941332.activate)
	c:RegisterEffect(e1)
end
function c68941332.filter(c,check)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
		and (check or c:IsAbleToChangeControler())
end
function c68941332.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and (c:IsControler(tp) or c:IsFaceup())
		and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
		and Duel.IsExistingTarget(c68941332.filter,tp,0,LOCATION_MZONE,1,c)
end
function c68941332.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckReleaseGroup(REASON_COST,tp,c68941332.rfilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(68941332,0)) then
		local g=Duel.SelectReleaseGroup(REASON_COST,tp,c68941332.rfilter,1,1,nil,tp)
		Duel.Release(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c68941332.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=e:GetLabel()==0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c68941332.filter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c68941332.filter,tp,0,LOCATION_MZONE,1,nil,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c68941332.filter,tp,0,LOCATION_MZONE,1,1,nil,check)
	if not check then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function c68941332.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetDescription(aux.Stringid(68941332,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		if e:GetLabel()==1 then
			Duel.BreakEffect()
			if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(RACE_PLANT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
	end
end
