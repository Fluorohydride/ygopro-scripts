--クロス・ブリード
---@param c Card
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
		and Duel.IsExistingMatchingCard(c20862918.costfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,c:GetOriginalRace(),c:GetOriginalAttribute(),c:GetCode(),tp)
end
function c20862918.costfilter2(c,race,att,code,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and c:GetOriginalRace()==race and c:GetOriginalAttribute()==att and not c:IsCode(code)
		and Duel.IsExistingMatchingCard(c20862918.thfilter,tp,LOCATION_DECK,0,1,nil,race,att,code,c:GetCode())
end
function c20862918.thfilter(c,race,att,code1,code2)
	return c:GetOriginalRace()==race and c:GetOriginalAttribute()==att and not c:IsCode(code1,code2)
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
	local race=g1:GetFirst():GetOriginalRace()
	local att=g1:GetFirst():GetOriginalAttribute()
	local code=g1:GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c20862918.costfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,g1:GetFirst(),race,att,code,tp)
	e:SetLabel(race,att,code,g2:GetFirst():GetCode())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20862918.activate(e,tp,eg,ep,ev,re,r,rp)
	local race,att,code1,code2=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20862918.thfilter,tp,LOCATION_DECK,0,1,1,nil,race,att,code1,code2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
