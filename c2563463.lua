--流離のグリフォンライダー
function c2563463.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2563463,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2563463)
	e1:SetCondition(c2563463.spcon)
	e1:SetTarget(c2563463.sptg)
	e1:SetOperation(c2563463.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2563463,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,2563464)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c2563463.negcon)
	e2:SetTarget(c2563463.negtg)
	e2:SetOperation(c2563463.negop)
	c:RegisterEffect(e2)
end
function c2563463.cfilter(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c2563463.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(c2563463.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c2563463.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c2563463.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c2563463.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c2563463.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c2563463.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c2563463.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
