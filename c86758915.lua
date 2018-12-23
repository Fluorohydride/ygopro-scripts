--魔神儀の祝誕
function c86758915.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,nil,nil,nil,c86758915.mfilter)
	e1:SetDescription(aux.Stringid(86758915,0))
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86758915,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,86758915)
	e2:SetCost(c86758915.thcost)
	e2:SetTarget(c86758915.thtg)
	e2:SetOperation(c86758915.thop)
	c:RegisterEffect(e2)
end
function c86758915.mfilter(c)
	return c:IsSetCard(0x117)
end
function c86758915.cfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x117) and not c:IsCode(86758915)
		and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
end
function c86758915.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86758915.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c86758915.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c86758915.spfilter(c,e,tp)
	return c:IsSetCard(0x117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86758915.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c86758915.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c86758915.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c86758915.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
