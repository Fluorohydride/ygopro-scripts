--ヴォルカニック・インフェルノ
function c84138874.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negative
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84138874,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,84138874)
	e2:SetCondition(c84138874.discon)
	e2:SetCost(c84138874.discost)
	e2:SetTarget(c84138874.distg)
	e2:SetOperation(c84138874.disop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84138874,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,84138875)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c84138874.tdcon)
	e3:SetTarget(c84138874.tdtg)
	e3:SetOperation(c84138874.tdop)
	c:RegisterEffect(e3)
end
function c84138874.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and re:GetActivateLocation()==LOCATION_MZONE
end
function c84138874.cfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c84138874.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84138874.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c84138874.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if g:GetFirst():IsSetCard(0x32) then e:SetLabel(1)
	else e:SetLabel(0) end
end
function c84138874.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c84138874.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 and e:GetLabel()>0
		and Duel.SelectYesNo(tp,aux.Stringid(84138874,2)) then
		Duel.BreakEffect()
		Duel.NegateEffect(ev)
	end
end
function c84138874.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
end
function c84138874.tdfilter(c)
	return c:IsSetCard(0x32) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c84138874.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c84138874.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84138874.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84138874.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c84138874.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain()
	if #sg==0 then return end
	aux.PlaceCardsOnDeckBottom(tp,sg)
end
