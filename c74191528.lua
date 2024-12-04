--運命の一枚
function c74191528.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74191528+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c74191528.target)
	e1:SetOperation(c74191528.activate)
	c:RegisterEffect(e1)
end
function c74191528.filter(c)
	return c:IsAbleToHand()
end
function c74191528.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74191528.filter,tp,LOCATION_DECK,0,5,nil)
		and Duel.IsExistingMatchingCard(c74191528.filter,1-tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c74191528.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<5
		or not Duel.IsExistingMatchingCard(c74191528.filter,tp,LOCATION_DECK,0,1,nil)
		or not Duel.IsExistingMatchingCard(c74191528.filter,1-tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74191528,0))
	local g1=Duel.SelectMatchingCard(tp,c74191528.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(74191528,0))
	local g2=Duel.SelectMatchingCard(1-tp,c74191528.filter,1-tp,LOCATION_DECK,0,1,1,nil)
	Duel.BreakEffect()
	--[[ need Duel.RandomSelect to be updated for manually select
	local tg1=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,g1:GetFirst())
	local tg2=Duel.GetMatchingGroup(nil,1-tp,LOCATION_DECK,0,g2:GetFirst())
	local og2=tg2:RandomSelect(tp,4)
	local og1=tg1:RandomSelect(1-tp,4)
	g1:Merge(og1)
	g2:Merge(og2)
	local sg1=g1:RandomSelect(tp,1)
	local sg2=g2:RandomSelect(1-tp,1)
	]]--
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74191528,1))
	local og2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_DECK,4,4,g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(74191528,1))
	local og1=Duel.SelectMatchingCard(1-tp,nil,1-tp,0,LOCATION_DECK,4,4,g1:GetFirst())
	g1:Merge(og1)
	g2:Merge(og2)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74191528,2))
	local sg2=g2:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(74191528,2))
	local sg1=g1:Select(1-tp,1,1,nil)
	--
	Duel.SendtoHand(sg1,tp,REASON_EFFECT)
	Duel.SendtoHand(sg2,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,sg2)
	Duel.ConfirmCards(1-tp,sg1)
end
