--オルフェゴール・トロイメア
function c4055337.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c4055337.indval)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,4055337)
	e2:SetCondition(c4055337.atkcon1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c4055337.atktg)
	e2:SetOperation(c4055337.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e3:SetCondition(c4055337.atkcon2)
	c:RegisterEffect(e3)
end
function c4055337.indval(e,c)
	return c:IsType(TYPE_LINK)
end
function c4055337.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c4055337.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c4055337.tgfilter(c)
	return c:IsFaceup()
end
function c4055337.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave() and not c:IsCode(4055337)
end
function c4055337.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4055337.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4055337.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		 and Duel.IsExistingMatchingCard(c4055337.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c4055337.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c4055337.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4055337.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local gc=g:GetFirst()
		if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE)
			and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local lv=gc:GetLevel()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(lv*100)
			tc:RegisterEffect(e1)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c4055337.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c4055337.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
