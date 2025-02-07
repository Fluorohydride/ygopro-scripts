--真エクゾディア
function c37984331.initial_effect(c)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37984331.condition)
	e1:SetOperation(c37984331.operation)
	c:RegisterEffect(e1)
end
function c37984331.winfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40) and c:IsType(TYPE_NORMAL)
end
function c37984331.cfilter(c)
	return not c37984331.winfilter(c)
end
function c37984331.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37984331.winfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local ct=g:GetClassCount(Card.GetCode)
	return ct==4 and not Duel.IsExistingMatchingCard(c37984331.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c37984331.operation(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_TRUE_EXODIA = 0x20
	Duel.Win(1-tp,WIN_REASON_TRUE_EXODIA)
	if Duel.GetCurrentChain()==0 then Duel.Readjust() end
end
