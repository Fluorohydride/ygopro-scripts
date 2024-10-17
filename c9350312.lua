--丘と芽吹の春化精
---@param c Card
function c9350312.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9350312)
	e1:SetCost(c9350312.thcost)
	e1:SetTarget(c9350312.thtg)
	e1:SetOperation(c9350312.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9350312.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c9350312.costfilter(c)
	return (c:IsType(TYPE_MONSTER) or c:IsSetCard(0x182)) and c:IsDiscardable()
end
function c9350312.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,14108995)
	local b2=Duel.IsExistingMatchingCard(c9350312.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and (fe or b2) end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(14108995,0))) then
		Duel.Hint(HINT_CARD,0,14108995)
		fe:UseCountLimit(tp)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9350312.costfilter,tp,LOCATION_HAND,0,1,1,c)
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function c9350312.thfilter(c)
	return c:IsSetCard(0x182) and not c:IsCode(9350312) and c:IsAbleToHand()
end
function c9350312.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9350312.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9350312.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9350312.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9350312.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9350312.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9350312,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9350312.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9350312.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_EARTH)
end
function c9350312.indtg(e,c)
	return c:IsSetCard(0x182) and c:IsFaceup()
end
