--儚無みずき
function c60643553.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60643553,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60643553)
	e1:SetCondition(c60643553.condition)
	e1:SetCost(c60643553.cost)
	e1:SetOperation(c60643553.operation)
	c:RegisterEffect(e1)
end
function c60643553.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END
end
function c60643553.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60643553.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60643553.lpcon1)
	e1:SetOperation(c60643553.lpop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local g=Group.CreateGroup()
	g:KeepAlive()
	aux.RegisterEachTimeEvent(c,EVENT_SPSUMMON_SUCCESS,c60643553.cfilter,g,nil,60643554,RESET_PHASE+PHASE_END)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c60643553.lpcon2)
	e3:SetOperation(c60643553.lpop2)
	e3:SetLabelObject(g)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetOperation(c60643553.damop)
	e4:SetLabelObject(g)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c60643553.cfilter(c,e,sp)
	return c:IsType(TYPE_EFFECT)
		and c:IsSummonPlayer(1-sp) and c:IsFaceup()
end
function c60643553.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c60643553.cfilter,1,nil,e,tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and not Duel.IsChainSolving()
end
function c60643553.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c60643553.cfilter,nil,e,tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,60643553,RESET_PHASE+PHASE_END,0,1)
end
function c60643553.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,60643554)>0
end
function c60643553.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,60643554)
	local lg=e:GetLabelObject()
	lg=lg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,60643553,RESET_PHASE+PHASE_END,0,1)
end
function c60643553.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,60643553)<1 then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
	end
	e:GetLabelObject():DeleteGroup()
end
