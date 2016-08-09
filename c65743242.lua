--地縛霊の誘い
function c65743242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c65743242.condition)
	e1:SetTarget(c65743242.target)
	e1:SetOperation(c65743242.activate)
	c:RegisterEffect(e1)
end
function c65743242.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65743242.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ag=eg:GetFirst():GetAttackableTarget()
		local at=Duel.GetAttackTarget()
		return ag:IsExists(aux.TRUE,1,at)
	end
end
function c65743242.activate(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=ag:Select(tp,1,1,at)
	local tc=g:GetFirst()
	if tc then
		Duel.ChangeAttackTarget(tc)
	end
end
