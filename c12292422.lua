--標本の閲覧
---@param c Card
function c12292422.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12292422+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12292422.cost)
	e1:SetTarget(c12292422.target)
	e1:SetOperation(c12292422.operation)
	c:RegisterEffect(e1)
end
function c12292422.cfilter(c)
	return c:IsCode(59419719) and not c:IsPublic()
end
function c12292422.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12292422.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12292422.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c12292422.tgfilter0(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c12292422.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) then return false end
		local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		return mc>0 or g and g:IsExists(c12292422.tgfilter0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12292422.tgfilter(c,race,lv)
	return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsLevel(lv) and c:IsAbleToGrave()
end
function c12292422.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local race=Duel.AnnounceRace(tp,1,RACE_ALL)
		Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
		local lv=Duel.AnnounceLevel(tp)
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK)
		Duel.ConfirmCards(1-tp,cg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=cg:FilterSelect(1-tp,c12292422.tgfilter,1,1,nil,race,lv)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
