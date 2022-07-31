--Evil★Twin プレゼント
function c60759087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,60759087+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60759087.condition)
	e1:SetTarget(c60759087.target)
	e1:SetOperation(c60759087.activate)
	c:RegisterEffect(e1)
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
function c60759087.tgfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) c:IsFacedown() and c:IsAbleToDeck()
end
function c60759087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return false
		else
			return chkc:IsOnField() and chkc:IsControler(1-tp) and c60759087.tgfilter2(chkc)
		end
	end
	local b1=Duel.IsExistingTarget(c60759087.tgfilter1a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c60759087.tgfilter1b,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c60759087.tgfilter2,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(60759087,0),aux.Stringid(60759087,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(60759087,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(60759087,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_CONTROL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectTarget(tp,c60759087.tgfilter1a,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectTarget(tp,c60759087.tgfilter1b,tp,0,LOCATION_MZONE,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
	else
		e:SetCategory(CATEGORY_TODECK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c60759087.tgfilter2,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function c60759087.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local a=g:GetFirst()
		local b=g:GetNext()
		if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
			Duel.SwapControl(a,b)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
