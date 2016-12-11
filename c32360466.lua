--天地開闢
function c32360466.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32360466+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32360466.target)
	e1:SetOperation(c32360466.activate)
	c:RegisterEffect(e1)
end
function c32360466.filter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c32360466.filter2(c)
	return c:IsSetCard(0x10cf) or c:IsSetCard(0xbd)
end
function c32360466.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c32360466.filter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>2 and g:IsExists(c32360466.filter2,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c32360466.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32360466.filter1,tp,LOCATION_DECK,0,nil)
	if g:IsExists(c32360466.filter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:FilterSelect(tp,c32360466.filter2,1,1,nil)
		g:RemoveCard(sg1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:Select(tp,2,2,nil)
		sg1:Merge(sg2)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		local tg=sg1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		if c32360466.filter2(tc) and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg1:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
