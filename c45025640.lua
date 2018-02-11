--ボイコットン
function c45025640.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c45025640.damcon)
	e1:SetOperation(c45025640.damop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c45025640.thcon)
	e2:SetTarget(c45025640.thtg)
	e2:SetOperation(c45025640.thop)
	c:RegisterEffect(e2)
end
function c45025640.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c45025640.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-ep,ev,false)
	Duel.ChangeBattleDamage(ep,0,false)
end
function c45025640.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and bit.band(r,REASON_BATTLE)~=0
		and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c45025640.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c45025640.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
