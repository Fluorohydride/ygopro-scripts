--ウィッチクラフト・シュミッタ
function c21744288.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21744288,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21744288)
	e1:SetCondition(c21744288.spcon)
	e1:SetCost(c21744288.spcost)
	e1:SetTarget(c21744288.sptg)
	e1:SetOperation(c21744288.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21744288,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21744289)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c21744288.tgtg)
	e2:SetOperation(c21744288.tgop)
	c:RegisterEffect(e2)
end
function c21744288.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c21744288.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c21744288.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21744288.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c21744288.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
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
function c21744288.spfilter(c,e,tp)
	return c:IsSetCard(0x128) and not c:IsCode(21744288) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21744288.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c21744288.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21744288.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21744288.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21744288.tgfilter(c)
	return c:IsSetCard(0x128) and not c:IsCode(21744288) and c:IsAbleToGrave()
end
function c21744288.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21744288.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21744288.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21744288.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
