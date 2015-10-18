--Dinomist Stegosaurus
function c1580833.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c1580833.reptg)
	e2:SetValue(c1580833.repval)
	e2:SetOperation(c1580833.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36088082,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c1580833.regcon)
	e3:SetOperation(c1580833.regop)
	c:RegisterEffect(e3)
	
end
function c1580833.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1e71) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c1580833.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1580833.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(37752990,0))
end
function c1580833.repval(e,c)
	return c1580833.filter(c,e:GetHandlerPlayer())
end
function c1580833.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c1580833.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()~=Duel.GetAttacker() and Duel.GetAttackTarget()~=nil and e:GetHandler()~=Duel.GetAttackTarget())
	and ((Duel.GetAttacker():IsType(TYPE_PENDULUM) and Duel.GetAttacker():GetControler()==tp) or 
	(Duel.GetAttackTarget():IsType(TYPE_PENDULUM) and Duel.GetAttackTarget():GetControler()==tp))
end
function c1580833.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetOperation(c1580833.desop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1580833.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
	Duel.Destroy(Duel.GetAttackTarget(),REASON_EFFECT)
end
