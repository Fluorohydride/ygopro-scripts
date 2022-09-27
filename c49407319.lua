--スター・マイン
function c49407319.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(49407319)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49407319,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c49407319.damcon)
	e1:SetTarget(c49407319.damtg)
	e1:SetOperation(c49407319.damop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49407319,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c49407319.descon)
	e2:SetTarget(c49407319.destg)
	e2:SetOperation(c49407319.desop)
	c:RegisterEffect(e2)
end
function c49407319.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp)
		and (c:IsReason(REASON_EFFECT) and rp==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
end
function c49407319.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,2000)
end
function c49407319.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,2000,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end
function c49407319.filter(c,tp,rp,seq)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and ((c:IsReason(REASON_EFFECT) and rp==1-tp) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
		and c:GetPreviousSequence()<5 and math.abs(seq-c:GetPreviousSequence())==1
end
function c49407319.descon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>=5 then return false end
	return eg:IsExists(c49407319.filter,1,nil,tp,rp,seq)
end
function c49407319.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,2000)
end
function c49407319.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 and Duel.Damage(tp,2000,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end
