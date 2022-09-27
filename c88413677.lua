--ドヨン＠イグニスター
function c88413677.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88413677,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,88413677)
	e1:SetTarget(c88413677.thtg1)
	e1:SetOperation(c88413677.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88413677,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,88413678)
	e3:SetCondition(c88413677.thcon2)
	e3:SetTarget(c88413677.thtg2)
	e3:SetOperation(c88413677.thop2)
	c:RegisterEffect(e3)
end
function c88413677.thfilter1(c)
	return c:IsSetCard(0x135) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88413677.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88413677.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88413677.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c88413677.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88413677.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c88413677.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_GRAVE)
end
function c88413677.thfilter2(c)
	return c:IsSetCard(0x136) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c88413677.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88413677.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88413677.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c88413677.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88413677.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
