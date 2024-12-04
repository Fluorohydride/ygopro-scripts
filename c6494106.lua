--妬絶の呪眼
function c6494106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,6494106+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c6494106.condition)
	e1:SetTarget(c6494106.target)
	e1:SetOperation(c6494106.activate)
	c:RegisterEffect(e1)
end
function c6494106.filter(c)
	return c:IsSetCard(0x129) and c:IsFaceup()
end
function c6494106.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c6494106.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c6494106.filter1(c)
	return c:IsFaceup() and c:IsCode(44133040)
end
function c6494106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tg=1
	if Duel.IsExistingMatchingCard(c6494106.filter1,tp,LOCATION_SZONE,0,1,nil) then
		tg=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,tg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c6494106.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
