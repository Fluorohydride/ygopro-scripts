--御巫かみくらべ
function c78199891.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78199891,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,78199891)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c78199891.condition)
	e1:SetTarget(c78199891.target)
	e1:SetOperation(c78199891.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78199891,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,78199892)
	e2:SetCondition(c78199891.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c78199891.thtg)
	e2:SetOperation(c78199891.thop)
	c:RegisterEffect(e2)
end
function c78199891.cfilter(c)
	return c:IsSetCard(0x18d) and c:IsFaceup()
end
function c78199891.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78199891.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78199891.filter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c78199891.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c78199891.eqfilter(c,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(ec)
end
function c78199891.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c78199891.filter(chkc,tp) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingTarget(c78199891.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c78199891.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c78199891.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c78199891.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc):GetFirst()
		if sc then
			Duel.Equip(tp,sc,tc)
		end
	end
end
function c78199891.ctfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_EQUIP)
end
function c78199891.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78199891.ctfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c78199891.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c78199891.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c78199891.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78199891.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c78199891.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c78199891.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
