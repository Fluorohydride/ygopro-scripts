--盆回し
function c73468603.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73468603.target)
	e1:SetOperation(c73468603.operation)
	c:RegisterEffect(e1)
end
function c73468603.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c73468603.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c73468603.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
end
function c73468603.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c73468603.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73468603,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73468603,1))
	local tg2=g:Select(tp,1,1,nil)
	Duel.SSet(tp,tg1)
	Duel.SSet(1-tp,tg2)
	tg1:GetFirst():RegisterFlagEffect(73468603,RESET_EVENT+0x1fe0000,0,1)
	tg2:GetFirst():RegisterFlagEffect(73468603,RESET_EVENT+0x1fe0000,0,1)
	tg1:Merge(tg2)
	Duel.ConfirmCards(1-tp,tg1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c73468603.con)
	e1:SetValue(c73468603.actlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c73468603.con)
	e2:SetTarget(c73468603.setlimit)
	Duel.RegisterEffect(e2,tp)
end
function c73468603.cfilter(c)
	return c:IsFacedown() and c:GetFlagEffect(73468603)~=0
end
function c73468603.con(e)
	return Duel.IsExistingMatchingCard(c73468603.cfilter,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c73468603.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(73468603)==0
end
function c73468603.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and c:GetFlagEffect(73468603)==0
end
