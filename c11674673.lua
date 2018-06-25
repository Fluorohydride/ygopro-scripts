--サイバース・ウィッチ
function c11674673.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11674673,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11674673)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11674673.thcon)
	e1:SetCost(c11674673.thcost)
	e1:SetTarget(c11674673.thtg)
	e1:SetOperation(c11674673.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11674673,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11674674)
	e2:SetCondition(c11674673.spcon)
	e2:SetTarget(c11674673.sptg)
	e2:SetOperation(c11674673.spop)
	c:RegisterEffect(e2)
end
function c11674673.thcfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c11674673.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11674673.thcfilter,1,nil,e:GetHandler())
end
function c11674673.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c11674673.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11674673.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11674673.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11674673.thfilter1(c,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c11674673.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c11674673.thfilter2(c)
	return c:IsCode(34767865) and c:IsAbleToHand()
end
function c11674673.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11674673.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c11674673.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c11674673.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c11674673.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	Duel.RegisterFlagEffect(tp,11674673,RESET_PHASE+PHASE_END,0,1)
end
function c11674673.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11674673)>0
end
function c11674673.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11674673.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c11674673.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11674673.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11674673.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11674673.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
