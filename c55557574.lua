--神速召喚
function c55557574.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START)
	e1:SetCountLimit(1,55557574+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c55557574.condition)
	e1:SetTarget(c55557574.target)
	e1:SetOperation(c55557574.operation)
	c:RegisterEffect(e1)
end
function c55557574.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c55557574.checkfilter(c)
	return c:IsFaceup() and c:IsCode(64788463,25652259,90876561)
end
function c55557574.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsLevel(10)
end
function c55557574.thfilter(c)
	return c:GetTextAttack()==-2 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsLevel(10) and c:IsNonAttribute(ATTRIBUTE_DARK)
end
function c55557574.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c55557574.checkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c55557574.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		or (g:GetClassCount(Card.GetCode)==3 and Duel.IsExistingMatchingCard(c55557574.thfilter,tp,LOCATION_DECK,0,1,nil)) end
end
function c55557574.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55557574.checkfilter,tp,LOCATION_MZONE,0,nil)
	local check1=g:GetClassCount(Card.GetCode)==3
	local check2=Duel.IsExistingMatchingCard(c55557574.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	if check1 and Duel.IsExistingMatchingCard(c55557574.thfilter,tp,LOCATION_DECK,0,1,nil)
		and (not check2 or Duel.SelectYesNo(tp,aux.Stringid(55557574,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c55557574.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c55557574.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(55557574,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c55557574.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	elseif check2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c55557574.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
