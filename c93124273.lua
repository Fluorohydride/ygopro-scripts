--Samurai Calvary of Reptier
function c93124273.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93124273,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c93124273.target)
	e1:SetOperation(c93124273.operation)
	c:RegisterEffect(e1)
end
function c93124273.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk ==0 then	return Duel.GetAttacker()==e:GetHandler()
		and d and d:IsFaceup() and not d:IsType(TYPE_PENDULUM) and d:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c93124273.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
