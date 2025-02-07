--モンスターアソート
function c23270035.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,23270035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c23270035.target)
	e1:SetOperation(c23270035.activate)
	c:RegisterEffect(e1)
end
function c23270035.filter(c,g)
	return g:IsExists(c23270035.filter2,1,c,c) and c:IsType(TYPE_NORMAL)
end
function c23270035.filter2(c,cc)
	return c:IsRace(cc:GetRace()) and c:IsAttribute(cc:GetAttribute()) and c:IsLevel(cc:GetLevel()) and c:IsType(TYPE_EFFECT)
end
function c23270035.fselect(g)
	return g:IsExists(c23270035.filter,1,nil,g)
end
function c23270035.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c23270035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c23270035.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c23270035.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23270035.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23270035.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c23270035.fselect,false,2,2)
	if sg and #sg==2 then
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
