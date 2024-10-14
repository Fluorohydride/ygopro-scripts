--大霊術－「一輪」
---@param c Card
function c38057522.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c38057522.discon)
	e1:SetOperation(c38057522.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38057522,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,38057522)
	e2:SetTarget(c38057522.thtg)
	e2:SetOperation(c38057522.thop)
	c:RegisterEffect(e2)
end
function c38057522.disfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsDefense(1500)
end
function c38057522.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c38057522.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c38057522.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,38057522)
	Duel.NegateEffect(ev)
end
function c38057522.tdfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and not c:IsPublic() and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c38057522.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c38057522.thfilter(c,attr)
	return c:IsAttack(1500) and c:IsDefense(200) and c:IsAttribute(attr) and c:IsAbleToHand()
end
function c38057522.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38057522.tdfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c38057522.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c38057522.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,c38057522.thfilter,tp,LOCATION_DECK,0,1,1,nil,attr)
		local hc=hg:GetFirst()
		if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,hc)
			if hc:IsLocation(LOCATION_HAND) then
				Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
