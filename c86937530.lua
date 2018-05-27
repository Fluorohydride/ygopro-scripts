--妖精伝姫－カグヤ
function c86937530.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86937530,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c86937530.target)
	e1:SetOperation(c86937530.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86937530,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c86937530.thtg)
	e2:SetOperation(c86937530.thop)
	c:RegisterEffect(e2)
end
function c86937530.filter(c)
	return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c86937530.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86937530.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c86937530.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c86937530.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c86937530.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c86937530.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c86937530.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c86937530.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c86937530.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c86937530.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c86937530.cfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,tc:GetCode())
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(86937530,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	if tc:IsRelateToEffect(e) then
		local rg=Group.FromCards(c,tc)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
