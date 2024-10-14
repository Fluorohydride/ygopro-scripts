--メリアスの木霊
---@param c Card
function c64245689.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),3,2)
	c:EnableReviveLimit()
	--to grave&SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c64245689.cost)
	e1:SetTarget(c64245689.tgtg)
	e1:SetOperation(c64245689.tgop)
	c:RegisterEffect(e1)
end
function c64245689.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c64245689.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function c64245689.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c64245689.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c64245689.spfilter(chkc,e,tp) end
	local b1=Duel.IsExistingMatchingCard(c64245689.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c64245689.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(64245689,0),aux.Stringid(64245689,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(64245689,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(64245689,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c64245689.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c64245689.tgop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c64245689.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsRace(RACE_PLANT) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
