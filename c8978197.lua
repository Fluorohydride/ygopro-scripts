--ロード・オブ・ドラゴン－ドラゴンの統制者－
---@param c Card
function c8978197.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,17985575)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8978197,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c8978197.thcost)
	e2:SetTarget(c8978197.thtg)
	e2:SetOperation(c8978197.thop)
	c:RegisterEffect(e2)
end
function c8978197.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c8978197.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8978197.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c8978197.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c8978197.thfilter(c)
	return c:IsCode(71867500,43973174,48800175) and c:IsAbleToHand()
end
function c8978197.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8978197.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8978197.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8978197.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
