--ファラオの審判
function c55948544.initial_effect(c)
	--Activate (YU-JYO)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55948544,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c55948544.condition1)
	e1:SetCost(c55948544.cost)
	e1:SetOperation(c55948544.operation1)
	c:RegisterEffect(e1)
	--Activate (UNITY)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55948544,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c55948544.condition2)
	e2:SetCost(c55948544.cost)
	e2:SetOperation(c55948544.operation2)
	c:RegisterEffect(e2)
end
function c55948544.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,81332143)
end
function c55948544.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c55948544.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,81332143) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetTargetRange(0,1)
	e6:SetValue(c55948544.aclimit1)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetTarget(c55948544.distg1)
	e7:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e7,tp)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetCondition(c55948544.discon1)
	e8:SetOperation(c55948544.disop)
	e8:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e8,tp)
end
function c55948544.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c55948544.distg1(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end
function c55948544.discon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c55948544.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c55948544.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,14731897)
end
function c55948544.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,14731897) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c55948544.aclimit2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c55948544.distg2)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetCondition(c55948544.discon2)
	e5:SetOperation(c55948544.disop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c55948544.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c55948544.distg2(e,c)
	return c:IsType(TYPE_TRAP)
end
function c55948544.discon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-tp
end
