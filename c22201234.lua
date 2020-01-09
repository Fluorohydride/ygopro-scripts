--ライトロード・バリア
function c22201234.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--quick
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(22201234,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c22201234.qcon)
	e2:SetCost(c22201234.qcost)
	e2:SetTarget(c22201234.qtg)
	e2:SetOperation(c22201234.qop)
	c:RegisterEffect(e2)
end
function c22201234.qcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsSetCard(0x38) and d:IsControler(tp)
end
function c22201234.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(22201234)==0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,2) end
	e:GetHandler():RegisterFlagEffect(22201234,RESET_CHAIN,0,1)
	Duel.DiscardDeck(tp,2,REASON_COST)
end
function c22201234.qtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c22201234.qop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
