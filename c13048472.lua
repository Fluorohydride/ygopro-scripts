--儀式の下準備
function c13048472.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13048472+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13048472.target)
	e1:SetOperation(c13048472.activate)
	c:RegisterEffect(e1)
end
function c13048472.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c13048472.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c13048472.filter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and c13048472.isfit(c,mc)
end
function c13048472.isfit(c,mc)
	return mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))
end
function c13048472.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13048472.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13048472.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13048472.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c13048472.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
