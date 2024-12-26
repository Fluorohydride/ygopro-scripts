--ハーピィ・レディ・SC
---@param c Card
function c63261835.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c63261835.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--change name
	aux.EnableChangeCode(c,76812113,LOCATION_MZONE+LOCATION_GRAVE)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63261835,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,63261835)
	e2:SetCondition(c63261835.thcon)
	e2:SetTarget(c63261835.thtg)
	e2:SetOperation(c63261835.thop)
	c:RegisterEffect(e2)
end
function c63261835.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0x64)
end
function c63261835.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c63261835.thfilter(c,tp)
	return (c:IsControler(1-tp) or (c:IsFaceup() and c:IsSetCard(0x64))) and c:IsAbleToHand()
end
function c63261835.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c63261835.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c63261835.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c63261835.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c63261835.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
