--幻奏の歌姫ソプラノ
function c62895219.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,62895219)
	e1:SetTarget(c62895219.thtg)
	e1:SetOperation(c62895219.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x9b),
		mat_location=LOCATION_MZONE,
		include_this_card=true,
		reg=false
	})
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c62895219.filter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) and not c:IsCode(62895219) and c:IsAbleToHand()
end
function c62895219.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c62895219.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62895219.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c62895219.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c62895219.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
