--DD魔導賢者ニコラ
---@param c Card
function c46035545.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c46035545.splimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46035545,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c46035545.atkcost)
	e2:SetTarget(c46035545.atktg)
	e2:SetOperation(c46035545.atkop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,46035545)
	e3:SetCondition(c46035545.thcon)
	e3:SetTarget(c46035545.thtg)
	e3:SetOperation(c46035545.thop)
	c:RegisterEffect(e3)
end
function c46035545.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xaf) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c46035545.atkcfilter(c)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c46035545.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46035545.atkcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c46035545.atkcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c46035545.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsLevelBelow(6)
end
function c46035545.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c46035545.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c46035545.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c46035545.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c46035545.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c46035545.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_PZONE)
end
function c46035545.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:IsAbleToHand()
end
function c46035545.pfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c46035545.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c46035545.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c46035545.thfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c46035545.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c46035545.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c46035545.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_HAND) then
		local ct=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c46035545.pfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
		local pc=g:GetFirst()
		while pc do
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e1,true)
			pc=g:GetNext()
		end
	end
end
