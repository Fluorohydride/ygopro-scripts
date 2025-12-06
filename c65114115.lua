--七星天流抜刀術－「破軍」
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.thcon2)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode(),c:GetRace(),tp)
end
function s.eqfilter(c,code,race,tp)
	return not c:IsCode(code) and c:IsType(TYPE_MONSTER)
		and c:IsLevel(7) and c:IsRace(race)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>ct end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetCode(),tc:GetRace(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(700)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		local fid=sc:GetFieldID()
		sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sc)
		e3:SetCondition(s.thcon1)
		e3:SetOperation(s.thop1)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else
		return true
	end
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function s.thcfilter(c,tp)
	return (c:GetPreviousLevelOnField()>=8 or c:GetPreviousRankOnField()>=8) and c:IsPreviousControler(1-tp)
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
