--Score the Melodious Diva
function c41767843.initial_effect(c)
	--atkdef 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41767843,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c41767843.con)
	e1:SetCost(c41767843.cos)
	e1:SetOperation(c41767843.op)
	c:RegisterEffect(e1)
end
function c41767843.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsSetCard(0x9b) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsSetCard(0x9b) and d:IsRelateToBattle())
end
function c41767843.cos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c41767843.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if a:GetControler()==tp then
		e1:SetValue(0)
		d:RegisterEffect(e1)
	else
		e1:SetValue(0)
		a:RegisterEffect(e1)
	end
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENCE)
	if a:GetControler()==tp then
		e2:SetValue(0)
		d:RegisterEffect(e2)
	else
		e2:SetValue(0)
		a:RegisterEffect(e2)
	end
end