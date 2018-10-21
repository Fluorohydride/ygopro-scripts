--幻創龍ファンタズメイ
function c78661338.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78661338,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,78661338)
	e1:SetCondition(c78661338.spcon)
	e1:SetTarget(c78661338.sptg)
	e1:SetOperation(c78661338.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78661338,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,78661339)
	e2:SetCondition(c78661338.discon)
	e2:SetCost(c78661338.discost)
	e2:SetTarget(c78661338.distg)
	e2:SetOperation(c78661338.disop)
	c:RegisterEffect(e2)
end
function c78661338.spfilter(c,sp)
	return c:GetSummonPlayer()==sp and c:IsType(TYPE_LINK)
end
function c78661338.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78661338.spfilter,1,nil,1-tp)
end
function c78661338.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_LINK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,ct+1)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78661338.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_LINK)
		if Duel.Draw(tp,ct+1,REASON_EFFECT)==0 then return end
		Duel.ShuffleHand(tp)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c78661338.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c78661338.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c78661338.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c78661338.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c78661338.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c78661338.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c78661338.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
