--砂塵の大ハリケーン
---@param c Card
function c35479109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,35479109+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c35479109.target)
	e1:SetOperation(c35479109.activate)
	c:RegisterEffect(e1)
end
function c35479109.filter(c)
	return c:IsFacedown() and c:GetSequence()<5 and c:IsAbleToHand()
end
function c35479109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c35479109.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c35479109.filter,tp,LOCATION_SZONE,0,1,c) and c:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c35479109.filter,tp,LOCATION_SZONE,0,1,5,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c35479109.cfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFacedown()
end
function c35479109.fselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and #g-fc<=ft
end
function c35479109.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c35479109.cfilter,nil,e)
	if c:IsRelateToEffect(e) and tg:GetCount()>0 then
		c:CancelToGrave()
		tg:AddCard(c)
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
			local g=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
			if #og>0 and g:CheckSubGroup(c35479109.fselect,#og,#og,ft) and Duel.SelectYesNo(tp,aux.Stringid(35479109,0)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=g:SelectSubGroup(tp,c35479109.fselect,false,#og,#og,ft)
				Duel.SSet(tp,sg,tp,false)
			end
		end
	end
end
