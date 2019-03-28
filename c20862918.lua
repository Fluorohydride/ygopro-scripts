--クロス・ブリード
function c20862918.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20862918+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c20862918.cost)
	e1:SetTarget(c20862918.target)
	e1:SetOperation(c20862918.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c20862918.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c20862918.costfilter1(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c20862918.costfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,c,tp)
end
function c20862918.costfilter2(c,tc,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and c:GetOriginalRace()==tc:GetOriginalRace() and c:GetOriginalAttribute()==tc:GetOriginalAttribute() 
		and not c:IsCode(tc:GetCode())
		and Duel.IsExistingMatchingCard(c20862918.thfilter,tp,LOCATION_DECK,0,1,nil,c,tc)
end
function c20862918.thfilter(c,tc1,tc2)
	return c:GetOriginalRace()==tc1:GetOriginalRace() and c:GetOriginalAttribute()==tc1:GetOriginalAttribute()
		and not c:IsCode(tc1:GetCode()) and not c:IsCode(tc2:GetCode())
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c20862918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c20862918.costfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c20862918.costfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c20862918.costfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst(),tp)
	g1:Merge(g2)
	g1:KeepAlive()
	e:SetLabelObject(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20862918.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local tc1=tg:GetFirst()
	local tc2=tg:GetNext()
	tg:DeleteGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20862918.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc1,tc2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
