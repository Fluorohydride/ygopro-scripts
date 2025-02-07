--スモール・ワールド
function c89558743.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,89558743+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c89558743.target)
	e1:SetOperation(c89558743.operation)
	c:RegisterEffect(e1)
end
function c89558743.same_check(c,mc)
	local flag=0
	if c:GetRace()==mc:GetRace() then flag=flag+1 end
	if c:GetAttribute()==mc:GetAttribute() then flag=flag+1 end
	if c:GetLevel()==mc:GetLevel() then flag=flag+1 end
	if c:GetTextAttack()==mc:GetTextAttack() then flag=flag+1 end
	if c:GetTextDefense()==mc:GetTextDefense() then flag=flag+1 end
	return flag==1
end
function c89558743.filter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEDOWN) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c89558743.filter2,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c89558743.filter2(c,tp,mc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEDOWN) and c89558743.same_check(c,mc)
		and Duel.IsExistingMatchingCard(c89558743.filter3,tp,LOCATION_DECK,0,1,nil,c)
end
function c89558743.filter3(c,mc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c89558743.same_check(c,mc)
end
function c89558743.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c89558743.filter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c89558743.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c89558743.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c89558743.filter2,tp,LOCATION_DECK,0,1,1,nil,tp,g1:GetFirst())
	Duel.ConfirmCards(1-tp,g2)
	if g2:GetCount()~=0 and Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,c89558743.filter3,tp,LOCATION_DECK,0,1,1,nil,g2:GetFirst())
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
			Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
