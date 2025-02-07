--福悲喜
function c54927180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c54927180.target)
	e1:SetOperation(c54927180.activate)
	c:RegisterEffect(e1)
end
function c54927180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) end
end
function c54927180.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
		or not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) then return end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if not tc1 or not tc2 then return end
	local atk1,atk2=0,0
	if not tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc1:GetTextAttack()>=0 then
		atk1=tc1:GetTextAttack()
	end
	if not tc2:IsType(TYPE_SPELL+TYPE_TRAP) and tc2:GetTextAttack()>=0 then
		atk2=tc2:GetTextAttack()
	end
	if atk1>atk2 then
		if not tc1:IsAbleToHand() then return end
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc1,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc2,REASON_EFFECT)
		end
	elseif atk1<atk2 then
		if not tc2:IsAbleToHand() then return end
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc2,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(1-tp)
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc1,REASON_EFFECT)
		end
	else
		Duel.MoveSequence(tc1,SEQ_DECKBOTTOM)
		Duel.MoveSequence(tc2,SEQ_DECKBOTTOM)
	end
end
