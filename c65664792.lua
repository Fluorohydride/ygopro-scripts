--華麗なるハーピィ・レディ
function c65664792.initial_effect(c)
	aux.AddCodeList(c,12206212)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65664792)
	e1:SetTarget(c65664792.target)
	e1:SetOperation(c65664792.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65664793)
	e2:SetCondition(c65664792.thcon)
	e2:SetTarget(c65664792.thtg)
	e2:SetOperation(c65664792.thop)
	c:RegisterEffect(e2)
end
function c65664792.tdfilter(c)
	return c:IsCode(12206212) and c:IsAbleToDeck()
end
function c65664792.spfilter(c,e,tp)
	return c:IsSetCard(0x64) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65664792.spfilter1(c,e,tp)
	return c65664792.spfilter(c,e,tp)
		and Duel.IsExistingMatchingCard(c65664792.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c65664792.spfilter2(c,e,tp,c1)
	return c65664792.spfilter(c,e,tp)
		and not c:IsOriginalCodeRule(c1:GetOriginalCodeRule())
		and Duel.IsExistingMatchingCard(c65664792.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,c1,c)
end
function c65664792.spfilter3(c,e,tp,c1,c2)
	return c65664792.spfilter(c,e,tp)
		and not c:IsOriginalCodeRule(c1:GetOriginalCodeRule())
		and not c:IsOriginalCodeRule(c2:GetOriginalCodeRule())
end
function c65664792.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65664792.tdfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
end
function c65664792.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,c65664792.tdfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #dg>0 and Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c65664792.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(65664792,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=Duel.SelectMatchingCard(tp,c65664792.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(tp,c65664792.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=Duel.SelectMatchingCard(tp,c65664792.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sg1:GetFirst(),sg2:GetFirst())
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c65664792.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65664792.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c65664792.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and (rp==1-tp or (rp==tp and re:GetHandler():IsSetCard(0x64))) and c:IsPreviousControler(tp)
end
function c65664792.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64) and c:IsAbleToHand()
end
function c65664792.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65664792.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65664792.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
