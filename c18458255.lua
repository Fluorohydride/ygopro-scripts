--ネムレリアの寝姫楼
function c18458255.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,18458255)
	e1:SetCost(c18458255.cost)
	e1:SetTarget(c18458255.target)
	e1:SetOperation(c18458255.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(18458255,ACTIVITY_SPSUMMON,c18458255.counterfilter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c18458255.repcon)
	e2:SetTarget(c18458255.reptg)
	e2:SetValue(c18458255.repval)
	e2:SetOperation(c18458255.repop)
	c:RegisterEffect(e2)
end
function c18458255.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_PENDULUM)
end
function c18458255.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c18458255.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetCustomActivityCount(18458255,tp,ACTIVITY_SPSUMMON)==0
	local g=Duel.GetMatchingGroup(c18458255.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>=2 and check end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c18458255.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,2,2,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c18458255.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c18458255.filter(c)
	return c:IsLevel(10) and c:IsRace(RACE_BEAST) and c:IsAbleToHand()
end
function c18458255.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c18458255.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c18458255.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18458255.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if not sg then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c18458255.reprmfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end
function c18458255.repcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,1,nil,70155677)
end
function c18458255.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup()
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x191)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function c18458255.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c18458255.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c18458255.reprmfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c18458255.repval(e,c)
	return c18458255.repfilter(c,e:GetHandlerPlayer())
end
function c18458255.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,18458255)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18458255.reprmfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
end
