--烙印断罪
function c17751597.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,17751597)
	e1:SetCondition(c17751597.condition)
	e1:SetTarget(c17751597.target)
	e1:SetOperation(c17751597.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,17751597)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c17751597.thtg)
	e2:SetOperation(c17751597.thop)
	c:RegisterEffect(e2)
end
function c17751597.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c17751597.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsAbleToExtra()
end
function c17751597.filter2(c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsAbleToExtra()
end
function c17751597.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17751597.filter1,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(c17751597.filter2,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c17751597.fselect(sg)
	if #sg==1 then
		return sg:GetFirst():IsLocation(LOCATION_MZONE)
	else
		return sg:GetFirst():IsLocation(LOCATION_GRAVE) and sg:GetNext():IsLocation(LOCATION_GRAVE)
	end
end
function c17751597.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c17751597.filter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c17751597.filter2),tp,LOCATION_GRAVE,0,nil)
	if #g1==0 and #g2==0 then return end
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=g1:SelectSubGroup(tp,c17751597.fselect,false,1,2)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
	local fg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	if #fg~=#g then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c17751597.thfilter(c)
	return not c:IsCode(17751597) and c:IsSetCard(0x15d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c17751597.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17751597.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17751597.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17751597.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17751597.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
