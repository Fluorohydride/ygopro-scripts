--トライブ・ドライブ
---@param c Card
function c90969892.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90969892+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c90969892.target)
	e1:SetOperation(c90969892.operation)
	c:RegisterEffect(e1)
end
function c90969892.filter(c,e,tp,race)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsRace(race)
end
function c90969892.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ct1=mg:GetClassCount(Card.GetRace)
	local mc=mg:GetFirst()
	local mrc=0
	while mc do
		mrc=mrc|mc:GetRace()
		mc=mg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c90969892.filter,tp,LOCATION_DECK,0,nil,e,tp,mrc)
	local ct2=g:GetClassCount(Card.GetRace)
	if chk==0 then return ct1>=3 and ct2>=3 and g:CheckSubGroup(aux.drccheck,3,3) end
end
function c90969892.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ct1=mg:GetClassCount(Card.GetRace)
	local mc=mg:GetFirst()
	local mrc=0
	while mc do
		mrc=mrc|mc:GetRace()
		mc=mg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c90969892.filter,tp,LOCATION_DECK,0,nil,e,tp,mrc)
	local ct2=g:GetClassCount(Card.GetRace)
	if ct1<3 or ct2<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,3,3)
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectOption(tp,1190,1152)==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		sg:RemoveCard(tc)
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(sg:GetFirst(),SEQ_DECKTOP)
		Duel.MoveSequence(sg:GetNext(),SEQ_DECKTOP)
		Duel.SortDecktop(tp,tp,2)
		for i=1,2 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
