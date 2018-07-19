--通販売員
function c89928517.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c89928517.target)
	e1:SetOperation(c89928517.operation)
	c:RegisterEffect(e1)
end
function c89928517.filter(c)
	return not c:IsPublic()
end
function c89928517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c89928517.filter,tp,LOCATION_HAND,0,nil)*Duel.GetMatchingGroupCount(c89928517.filter,tp,0,LOCATION_HAND,nil)>0 end
end
function c89928517.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg1=Duel.GetMatchingGroup(c89928517.filter,tp,LOCATION_HAND,0,nil)
	local hg2=Duel.GetMatchingGroup(c89928517.filter,tp,0,LOCATION_HAND,nil)
	if #hg1==0 or #hg2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc1=hg1:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local tc2=hg2:Select(1-tp,1,1,nil):GetFirst()
	local tg=Group.FromCards(tc1,tc2)
	Duel.ConfirmCards(tp,tg)
	if tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) then
		local i=0
		local p=tp
		while i<=1 do
			local tc=tg:Filter(Card.IsControler,nil,p):GetFirst()
			if Duel.GetLocationCount(p,LOCATION_MZONE)>0
				and tc:IsCanBeSpecialSummoned(e,0,p,false,false)
				and Duel.SelectYesNo(p,aux.Stringid(89928517,1)) then
				Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
			end
			i=i+1
			p=1-tp
		end
	elseif tc1:IsType(TYPE_SPELL) and tc2:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif tc1:IsType(TYPE_TRAP) and tc2:IsType(TYPE_TRAP)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,2,nil) then
		for p=0,1 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,LOCATION_DECK,0,2,2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
