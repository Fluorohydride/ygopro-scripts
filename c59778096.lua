--星遺物の選託
function c59778096.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59778096,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59778096+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c59778096.tgtg)
	e1:SetOperation(c59778096.tgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59778096,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,59778096+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c59778096.thcost)
	e2:SetTarget(c59778096.thtg)
	e2:SetOperation(c59778096.thop)
	c:RegisterEffect(e2)
end
function c59778096.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c59778096.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59778096.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59778096.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)	
end
function c59778096.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c59778096.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c59778096.rmfilter(c)
	return c:IsSetCard(0xfe) and c:IsAbleToRemoveAsCost()
end
function c59778096.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59778096.rmfilter,tp,LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c59778096.rmfilter,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c59778096.thfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function c59778096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59778096.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59778096.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59778096.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
