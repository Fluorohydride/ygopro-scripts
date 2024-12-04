--ペンデュラム・スケール
function c17885118.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17885118,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17885118+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c17885118.condition)
	e1:SetTarget(c17885118.target)
	e1:SetOperation(c17885118.operation)
	c:RegisterEffect(e1)
end
function c17885118.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==2
end
function c17885118.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c17885118.thfilter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(2) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c17885118.thfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(5) and c:IsLevelBelow(7) and c:IsAbleToHand()
end
function c17885118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	local dif=math.abs(scl1-scl2)
	if chk==0 then return
		(dif==0 and Duel.IsExistingMatchingCard(c17885118.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler()))
		or (dif>=1 and dif<=3 and Duel.IsExistingMatchingCard(c17885118.thfilter1,tp,LOCATION_DECK,0,1,nil))
		or (dif>=4 and dif<=6 and Duel.IsExistingMatchingCard(c17885118.thfilter2,tp,LOCATION_DECK,0,1,nil))
		or (dif>=7 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil)) end
	if dif==0 then
		local g=Duel.GetMatchingGroup(c17885118.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	end
	if dif>=1 and dif<=6 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
end
function c17885118.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 then return end
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	local dif=math.abs(scl1-scl2)
	local g1=Duel.GetMatchingGroup(c17885118.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c17885118.thfilter1,tp,LOCATION_DECK,0,nil)
	local g3=Duel.GetMatchingGroup(c17885118.thfilter2,tp,LOCATION_DECK,0,nil)
	local g4=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
	local b1=dif==0 and g1:GetCount()>=2
	local b2=dif>=1 and dif<=3 and g2:GetCount()>=1
	local b3=dif>=4 and dif<=6 and g3:GetCount()>=1
	local b4=dif>=7 and g4:GetCount()>=1
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g1:Select(tp,2,2,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if b3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if b4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g4:Select(tp,1,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		local fg=Duel.GetMatchingGroup(c17885118.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and fg:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(17885118,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local mg=fg:Select(tp,1,1,nil)
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c17885118.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
