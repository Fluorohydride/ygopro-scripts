--アクションマジック－フルターン
function c99004583.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99004583.condition)
	e1:SetTarget(c99004583.target)
	e1:SetOperation(c99004583.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99004583,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c99004583.setcost)
	e2:SetTarget(c99004583.settg)
	e2:SetOperation(c99004583.setop)
	c:RegisterEffect(e2)
end
function c99004583.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c99004583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99004583)==0 or Duel.GetFlagEffect(1-tp,99004583)==0 end
end
function c99004583.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c99004583.dcon)
	e1:SetOperation(c99004583.dop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,99004583,RESET_PHASE+PHASE_END,0,1)
end
function c99004583.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
end
function c99004583.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c99004583.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99004583.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99004583.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99004583.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99004583.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c99004583.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
