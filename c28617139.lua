--神鳥の来寇
function c28617139.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28617139,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28617139+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28617139.cost)
	e1:SetTarget(c28617139.target)
	e1:SetOperation(c28617139.activate)
	c:RegisterEffect(e1)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28617139,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28617139.lvtg)
	e2:SetOperation(c28617139.lvop)
	c:RegisterEffect(e2)
end
function c28617139.costfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsDiscardable()
end
function c28617139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28617139.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c28617139.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c28617139.thfilter(c)
	return c:IsSetCard(0x12d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28617139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28617139.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetAttribute)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c28617139.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28617139.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetAttribute)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,2,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c28617139.cffilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsLevelAbove(2) and not c:IsPublic()
end
function c28617139.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28617139.cffilter,tp,LOCATION_HAND,0,1,nil) end
end
function c28617139.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28617139.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,g:GetFirst():GetCode())
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
