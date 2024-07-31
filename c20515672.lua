--S－Force ナイトチェイサー
function c20515672.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c20515672.mat,1,1)
	c:EnableReviveLimit()
	--attack limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c20515672.attg)
	e1:SetValue(c20515672.atlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20515672,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,20515672)
	e2:SetCondition(c20515672.tdcon)
	e2:SetTarget(c20515672.tdtg)
	e2:SetOperation(c20515672.tdop)
	c:RegisterEffect(e2)
end
function c20515672.mat(c)
	return c:IsLinkSetCard(0x156) and not c:IsLinkType(TYPE_LINK)
end
function c20515672.atfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c20515672.attg(e,c)
	local cg=c:GetColumnGroup()
	e:SetLabelObject(c)
	return cg:IsExists(c20515672.atfilter,1,nil,e:GetHandlerPlayer())
end
function c20515672.atlimit(e,c)
	local lc=e:GetLabelObject()
	return lc:GetColumnGroup():IsContains(c)
end
function c20515672.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c20515672.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsAbleToDeck()
end
function c20515672.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20515672.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20515672.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20515672.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c20515672.spfilter(c,e,tp)
	return c:IsSetCard(0x156) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20515672.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c20515672.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		if ft>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(20515672,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
