--パーソナル・スプーフィング
function c53936268.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c53936268.target1)
	e1:SetOperation(c53936268.operation)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53936268,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c53936268.cost)
	e2:SetTarget(c53936268.target2)
	e2:SetOperation(c53936268.operation)
	c:RegisterEffect(e2)
end
function c53936268.cfilter(c)
	return c:IsSetCard(0x103) and c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c53936268.thfilter(c)
	return c:IsSetCard(0x103) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c53936268.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c53936268.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c53936268.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,94) then
		c53936268.cost(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		c:RegisterFlagEffect(53936268,RESET_PHASE+PHASE_END,0,1)
		c:RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	else
		e:SetCategory(0)
	end
end
function c53936268.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(53936268)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53936268.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c53936268.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53936268.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c53936268.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c53936268.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(53936268)==0
		and Duel.IsExistingMatchingCard(c53936268.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(53936268,RESET_PHASE+PHASE_END,0,1)
end
