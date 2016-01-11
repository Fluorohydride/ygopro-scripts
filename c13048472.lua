--儀式の下準備
function c13048472.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13048472)
	e1:SetTarget(c13048472.target)
	e1:SetOperation(c13048472.activate)
	c:RegisterEffect(e1)
end
function c13048472.filter1(c,tp)
	local code=c:GetCode()
	return c:GetType()==0x82 and c.fit_monster and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c13048472.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c13048472.filter2(c,tc)
	return c:IsCode(table.unpack(tc.fit_monster)) and bit.band(c:GetType(),0x81) and c:IsAbleToHand()
end
function c13048472.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13048472.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c13048472.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c13048472.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c13048472.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,g1:GetFirst())
		g1:Merge(g2)
		if g1:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
