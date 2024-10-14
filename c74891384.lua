--魔救の奇石－ラプタイト
---@param c Card
function c74891384.initial_effect(c)
	--to decktop1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74891384,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,74891384)
	e1:SetCondition(c74891384.dtcon1)
	e1:SetTarget(c74891384.dttg1)
	e1:SetOperation(c74891384.dtop1)
	c:RegisterEffect(e1)
	--to decktop2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74891384,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,74891385)
	e2:SetTarget(c74891384.dttg2)
	e2:SetOperation(c74891384.dtop2)
	c:RegisterEffect(e2)
end
function c74891384.dtcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSpecialSummonSetCard(0x140)
end
function c74891384.dtfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToDeck()
end
function c74891384.dttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74891384.dtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c74891384.dtop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c74891384.dtfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.HintSelection(g)
		end
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
function c74891384.texfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function c74891384.dttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c74891384.texfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c74891384.texfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c74891384.texfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c74891384.dtop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
