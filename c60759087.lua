--Evil★Twin プレゼント
function c60759087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60759087,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,60759087+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60759087.condition)
	e1:SetTarget(c60759087.target1)
	e1:SetOperation(c60759087.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60759087,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,60759087+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c60759087.condition)
	e2:SetTarget(c60759087.target2)
	e2:SetOperation(c60759087.activate2)
	c:RegisterEffect(e2)
end
function c60759087.cfilter(c,setcode)
	return c:IsSetCard(setcode) and c:IsFaceup()
end
function c60759087.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60759087.cfilter,tp,LOCATION_MZONE,0,1,nil,0x152)
		and Duel.IsExistingMatchingCard(c60759087.cfilter,tp,LOCATION_MZONE,0,1,nil,0x153)
end
function c60759087.tgfilter1a(c)
	local tp=c:GetControler()
	return c:IsSetCard(0x152,0x153)
		and c:IsFaceup() and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c60759087.tgfilter1b(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c60759087.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c60759087.tgfilter1a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c60759087.tgfilter1b,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c60759087.tgfilter1a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c60759087.tgfilter1b,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c60759087.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		Duel.SwapControl(a,b)
	end
end
function c60759087.tgfilter2(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c60759087.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c60759087.tgfilter1(chkc) and chkc:IsLocation(LOCATION_SZONE)
		and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c60759087.tgfilter2,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c60759087.tgfilter2,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c60759087.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
