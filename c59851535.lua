--ウィッチクラフト・ポトリー
function c59851535.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59851535,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,59851535)
	e1:SetCondition(c59851535.spcon)
	e1:SetCost(c59851535.spcost)
	e1:SetTarget(c59851535.sptg)
	e1:SetOperation(c59851535.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,59851536)
	e2:SetCondition(c59851535.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c59851535.thtg)
	e2:SetOperation(c59851535.thop)
	c:RegisterEffect(e2)
end
function c59851535.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c59851535.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c59851535.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59851535.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c59851535.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(83289866,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c59851535.spfilter(c,e,tp)
	return c:IsSetCard(0x128) and not c:IsCode(59851535) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59851535.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c59851535.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c59851535.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59851535.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c59851535.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c59851535.thfilter(c)
	return c:IsSetCard(0x128) and c:IsAbleToHand()
end
function c59851535.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c59851535.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59851535.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c59851535.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c59851535.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
