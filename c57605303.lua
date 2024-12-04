--武装竜の万雷
function c57605303.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57605303,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,57605303)
	e1:SetTarget(c57605303.target)
	e1:SetOperation(c57605303.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57605303,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,57605303)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c57605303.thtg)
	e2:SetOperation(c57605303.thop)
	c:RegisterEffect(e2)
end
function c57605303.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and Duel.IsExistingMatchingCard(c57605303.atkfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel())
end
function c57605303.atkfilter(c,lv)
	return c:IsSetCard(0x111) and c:IsLevelBelow(lv)
end
function c57605303.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c57605303.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c57605303.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c57605303.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c57605303.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c57605303.atkfilter,tp,LOCATION_GRAVE,0,nil,tc:GetLevel())
		local ct=g:GetClassCount(Card.GetCode)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--damage 0
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCondition(c57605303.damcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetOwnerPlayer(tp)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e3:SetCondition(c57605303.damcon2)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
		end
	end
end
function c57605303.damcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c57605303.damcon2(e)
	return 1-e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c57605303.thfilter(c)
	return c:IsSetCard(0x111) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c57605303.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c57605303.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57605303.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c57605303.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c57605303.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
