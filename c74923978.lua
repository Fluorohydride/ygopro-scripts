--強制接収
function c74923978.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DISCARD)
	e1:SetCondition(c74923978.condition)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DISCARD)
	e2:SetCondition(c74923978.condition2)
	e2:SetOperation(c74923978.operation2)
	c:RegisterEffect(e2)
	aux.RegisterEachTimeEvent(c,EVENT_DISCARD,c74923978.cfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c74923978.condition3)
	e3:SetOperation(c74923978.operation3)
	c:RegisterEffect(e3)
end
function c74923978.cfilter(c,e,tp)
	return c:IsPreviousControler(tp)
end
function c74923978.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74923978.cfilter,1,nil,e,tp)
end
function c74923978.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74923978.cfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c74923978.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,74923978)
	local ct=eg:FilterCount(c74923978.cfilter,nil,e,tp)
	Duel.DiscardHand(1-tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
end
function c74923978.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(74923978)>0
end
function c74923978.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,74923978)
	local ct=e:GetHandler():GetFlagEffectLabel(74923978)
	e:GetHandler():ResetFlagEffect(74923978)
	if ct then
		Duel.DiscardHand(1-tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
	end
end
