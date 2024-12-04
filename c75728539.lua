--新世廻
function c75728539.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75728539,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,75728539)
	e1:SetCondition(c75728539.condition)
	e1:SetTarget(c75728539.target)
	e1:SetOperation(c75728539.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75728539,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75728540)
	e2:SetCondition(c75728539.thcon)
	e2:SetTarget(c75728539.thtg)
	e2:SetOperation(c75728539.thop)
	c:RegisterEffect(e2)
end
function c75728539.cfilter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c75728539.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75728539.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c75728539.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsAbleToDeck()
end
function c75728539.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75728539.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75728539.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75728539.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c75728539.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local op=tc:GetOwner()
		local race=tc:GetRace()
		local lv=tc:GetLevel()|tc:GetRank()|tc:GetLink()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c75728539.srcon)
		e1:SetOperation(c75728539.srop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(op,race,lv)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75728539.srfilter(c,race,lv)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(race) and c:IsLevelBelow(lv-1) and c:IsAbleToHand()
end
function c75728539.srcon(e,tp,eg,ep,ev,re,r,rp)
	local op,race,lv=e:GetLabel()
	return Duel.IsExistingMatchingCard(c75728539.srfilter,op,LOCATION_DECK,0,1,nil,race,lv)
end
function c75728539.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75728539)
	local op,race,lv=e:GetLabel()
	if Duel.SelectYesNo(op,aux.Stringid(75728539,2)) then
		Duel.Hint(HINT_SELECTMSG,op,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(op,c75728539.srfilter,op,LOCATION_DECK,0,1,1,nil,race,lv)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT,op)
			Duel.ConfirmCards(1-op,g)
		end
	end
end
function c75728539.thfilter(c,tp)
	return c:IsSetCard(0x19a) and c:IsFaceup()
end
function c75728539.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75728539.thfilter,1,nil,tp)
end
function c75728539.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75728539.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
