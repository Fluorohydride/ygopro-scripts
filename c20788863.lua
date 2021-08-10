--サラマングレイト・ギフト
function c20788863.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw (to grave)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20788863,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,20788863)
	e2:SetCost(c20788863.cost)
	e2:SetTarget(c20788863.drtg1)
	e2:SetOperation(c20788863.drop1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e2)
	--draw (link)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20788863,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,20788863)
	e3:SetCondition(c20788863.drcon)
	e3:SetCost(c20788863.cost)
	e3:SetTarget(c20788863.drtg2)
	e3:SetOperation(c20788863.drop2)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e3)
	if not c20788863.global_check then
		c20788863.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c20788863.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20788863.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,c:GetCode()) then
		c:RegisterFlagEffect(20788863,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c20788863.cfilter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c20788863.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20788863.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c20788863.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c20788863.filter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c20788863.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c20788863.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20788863.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20788863.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c20788863.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x119) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(20788863)~=0
end
function c20788863.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20788863.lfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20788863.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c20788863.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
