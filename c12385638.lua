--Kozmourning
function c12385638.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c12385638.tdtg)
	e2:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e2)
	--damage conversion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c12385638.cost)
	e3:SetOperation(c12385638.operation)
	c:RegisterEffect(e3)
end
function c12385638.tdtg(e,c)
	return c:IsSetCard(0xd2)
end
function c12385638.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12385638.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c12385638.condition)
	e1:SetValue(c12385638.valcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12385638.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:IsSetCard(0xd2) and a:IsControler(tp)) or (d and d:IsSetCard(0xd2) and d:IsControler(tp))
end
function c12385638.valcon(e,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(c:GetControler(),12385638)==0 and bit.band(r,REASON_BATTLE)~=0 then
		c:RegisterFlagEffect(c:GetControler(),12385638,RESET_PHASE+PHASE_END,0,1)
		return true
	else
		return false
	end
end
