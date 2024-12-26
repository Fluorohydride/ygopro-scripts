--武装竜の震霆
---@param c Card
function c97091969.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97091969,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,97091969)
	e1:SetTarget(c97091969.target)
	e1:SetOperation(c97091969.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(97091969,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetTarget(c97091969.thtg)
	e2:SetOperation(c97091969.thop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c97091969.reptg)
	e3:SetOperation(c97091969.repop)
	e3:SetValue(c97091969.repval)
	c:RegisterEffect(e3)
end
function c97091969.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsLevelAbove(1)
end
function c97091969.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c97091969.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97091969.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c97091969.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c97091969.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetLevel()*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c97091969.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c97091969.thfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel())
end
function c97091969.thfilter(c,lv)
	return c:IsSetCard(0x111) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c97091969.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c97091969.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c97091969.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c97091969.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c97091969.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c97091969.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,tc:GetLevel())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c97091969.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c97091969.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and c:IsAbleToGrave() and eg:IsExists(c97091969.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c97091969.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c97091969.repval(e,c)
	return c97091969.repfilter(c,e:GetHandlerPlayer())
end
