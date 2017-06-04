--エーリアン・ハンター
function c62315111.initial_effect(c)
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(c62315111.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62315111,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c62315111.atcon)
	e2:SetOperation(c62315111.atop)
	c:RegisterEffect(e2)
end
function c62315111.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:GetCounter(0x100e)>0 then
		c:RegisterFlagEffect(62315111,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c62315111.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.bdcon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable() and c:GetFlagEffect(62315111)~=0
end
function c62315111.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
