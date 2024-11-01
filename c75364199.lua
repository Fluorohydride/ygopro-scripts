--相視相殺
---@param c Card
function c75364199.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetOperation(c75364199.activate)
	c:RegisterEffect(e1)
end
function c75364199.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c75364199.acttg)
	Duel.RegisterEffect(e2,tp)
end
function c75364199.acttg(e,re,tp)
	local tc=re:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	return g1:IsExists(Card.IsCode,1,nil,tc:GetCode()) and g2:IsExists(Card.IsCode,1,nil,tc:GetCode())
end
