--天極輝艦－熊斗竜巧
---@param c Card
function c33250142.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon restriction
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c33250142.splimit)
	c:RegisterEffect(e0)
	--to hand (deck)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33250142,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33250142.thcon1)
	e1:SetTarget(c33250142.thtg1)
	e1:SetOperation(c33250142.thop1)
	c:RegisterEffect(e1)
	--to hand (remove)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33250142,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33250142.thtg2)
	e2:SetOperation(c33250142.thop2)
	c:RegisterEffect(e2)
end
function c33250142.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(89771220)
end
function c33250142.cfilter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsControler(tp)
end
function c33250142.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c33250142.cfilter1,1,nil,tp)
end
function c33250142.thfilter1(c)
	return c:IsSetCard(0x163,0x154) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33250142.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33250142.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33250142.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33250142.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33250142.thfilter2(c)
	return c33250142.thfilter1(c) and c:IsFaceup()
end
function c33250142.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c33250142.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33250142.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33250142.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33250142.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
