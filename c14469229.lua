--宝玉の守護者
function c14469229.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c14469229.indtg)
	e1:SetValue(c14469229.indval)
	c:RegisterEffect(e1)
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14469229,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCost(c14469229.cost)
	e2:SetTarget(c14469229.target)
	e2:SetOperation(c14469229.operation)
	c:RegisterEffect(e2)
end
function c14469229.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT)
		and (c:IsSetCard(0x1034) or (c:IsLocation(LOCATION_MZONE) and (c:IsCode(79407975) or c:IsCode(79856792))))
end
function c14469229.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c14469229.indfilter,1,nil,tp) end
	return true
end
function c14469229.indval(e,c)
	return c14469229.indfilter(c,e:GetHandlerPlayer())
end
function c14469229.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c14469229.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a=d end
	if chk==0 then return d and a:IsSetCard(0x1034) end
	e:SetLabelObject(a)
end
function c14469229.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		local atk=tc:GetBaseAttack()
		local def=tc:GetBaseDefence()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(def*2)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetOperation(c14469229.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3)
	end
end
function c14469229.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
