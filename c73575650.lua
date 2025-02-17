--サブテラーの継承
function c73575650.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73575650+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c73575650.target)
	e1:SetOperation(c73575650.activate)
	c:RegisterEffect(e1)
end
function c73575650.tgfilter1(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c73575650.thfilter1,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetCode())
end
function c73575650.thfilter1(c,att,code)
	return c:IsAttribute(att) and not c:IsCode(code) and c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c73575650.tgfilter2(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_FLIP) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c73575650.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetOriginalLevel())
end
function c73575650.thfilter2(c,att,clv)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsAttribute(att) and lv<clv and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c73575650.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c73575650.tgfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c73575650.tgfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(73575650,0),aux.Stringid(73575650,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(73575650,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(73575650,1))+1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73575650.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c73575650.tgfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if tc1 and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c73575650.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tc1:GetAttribute(),tc1:GetCode())
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c73575650.tgfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if tc1 and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c73575650.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetAttribute(),tc1:GetOriginalLevel())
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
