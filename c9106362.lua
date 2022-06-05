--EMドラネコ
function c9106362.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Negate damage (direct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9106362,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9106362.dmcon1)
	e1:SetOperation(c9106362.dmop)
	c:RegisterEffect(e1)
	--Negate damage (monster)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9106362.dmcon2)
	e2:SetTarget(c9106362.dmtg)
	e2:SetOperation(c9106362.dmop)
	c:RegisterEffect(e2)
end
function c9106362.dmcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c9106362.dmcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler()
end
function c9106362.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsMonsterAttacking() end
end
function c9106362.dmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
