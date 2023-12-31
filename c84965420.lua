--ドライトロン流星群
function c84965420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,84965420+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c84965420.condition)
	e1:SetTarget(c84965420.target)
	e1:SetOperation(c84965420.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function c84965420.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c84965420.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAbleToDeck()
end
function c84965420.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c84965420.filter,tp,LOCATION_MZONE,0,1,nil)
		and aux.NegateSummonCondition() and eg:IsExists(c84965420.cfilter,1,nil,tp)
end
function c84965420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c84965420.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
