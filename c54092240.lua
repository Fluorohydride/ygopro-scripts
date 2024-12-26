--テセア聖霊器
---@param c Card
function c54092240.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54092240,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,54092240)
	e1:SetCondition(c54092240.sscon)
	e1:SetTarget(c54092240.sstg)
	e1:SetOperation(c54092240.ssop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54092240,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,54092241)
	e2:SetCost(c54092240.thcost)
	e2:SetTarget(c54092240.thtg)
	e2:SetOperation(c54092240.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(54092240,ACTIVITY_SPSUMMON,c54092240.counterfilter)
end
function c54092240.counterfilter(c)
	return aux.IsCodeOrListed(c,3285552)
end
function c54092240.cfilter(c)
	return c:IsFaceup() and c:IsCode(3285552)
end
function c54092240.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c54092240.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c54092240.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54092240.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c54092240.thcfilter(c)
	return aux.IsCodeListed(c,3285552) and not c:IsPublic()
end
function c54092240.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(54092240,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c54092240.thcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c54092240.thcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c54092240.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c54092240.splimit(e,c)
	return not c54092240.counterfilter(c)
end
function c54092240.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:GetType()~=TYPE_SPELL and aux.IsCodeListed(c,3285552) and c:IsAbleToHand()
end
function c54092240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54092240.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c54092240.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c54092240.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
