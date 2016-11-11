--エーリアン・ハンター
function c62315111.initial_effect(c)
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62315111,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c62315111.atcon)
	e1:SetOperation(c62315111.atop)
	c:RegisterEffect(e1)
end
function c62315111.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.bdcon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
		and c:GetBattleTarget():GetCounter(0x100e)>0
end
function c62315111.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
