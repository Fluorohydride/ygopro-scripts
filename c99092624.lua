--漆黒の薔薇の開華
function c99092624.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99092624.target)
	e1:SetOperation(c99092624.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_EFFECT)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99092624)
	e2:SetTarget(c99092624.tdtg)
	e2:SetOperation(c99092624.tdop)
	c:RegisterEffect(e2)
end
function c99092624.cfilter(c)
	return c:GetSequence()==5
end
function c99092624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c99092624.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		ct=ct+Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_FIELD)
		if ct==0 then return false end
		for p=0,1 do
			if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,99092625,0,0x4011,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,p) then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,0,PLAYER_ALL,0)
end
function c99092624.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c99092624.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	ct=ct+Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_FIELD)
	if ct==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	repeat
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,99092625,0,0x4011,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp)
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,99092625,0,0x4011,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp)
		if not (b1 or b2) then break end
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(99092624,1),aux.Stringid(99092624,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(99092624,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(99092624,2))+1
		end
		local p=tp
		if op>0 then p=1-tp end
		local token=Duel.CreateToken(tp,99092625)
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE)
		ct=ct-1
	until ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(99092624,0))
	Duel.SpecialSummonComplete()
end
function c99092624.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
		and (c:IsCode(73580471) or c:IsRace(RACE_PLANT))
end
function c99092624.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99092624.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c99092624.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99092624.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99092624.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c99092624.retcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetOperation(c99092624.retop)
		Duel.RegisterEffect(e1,tp)
		if c:IsRelateToEffect(e) then
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		end
	end
end
function c99092624.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c99092624.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
