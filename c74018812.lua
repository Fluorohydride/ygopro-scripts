--白銀の城の火吹炉
function c74018812.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74018812,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,74018812)
	e1:SetCost(c74018812.stcost)
	e1:SetTarget(c74018812.sttg)
	e1:SetOperation(c74018812.stop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74018812,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,74018813)
	e2:SetCondition(c74018812.spcon)
	e2:SetTarget(c74018812.sptg)
	e2:SetOperation(c74018812.spop)
	c:RegisterEffect(e2)
end
function c74018812.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x17e) and c:IsSSetable()
end
function c74018812.costfilter(c,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c74018812.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c)
end
function c74018812.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c74018812.costfilter,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.DiscardHand(tp,c74018812.costfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function c74018812.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74018812.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c74018812.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c74018812.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c74018812.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c74018812.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and rp==tp and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetOriginalType()==TYPE_TRAP
		and eg:IsExists(c74018812.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c74018812.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c74018812.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
