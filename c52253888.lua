--ライトローミディアム
function c52253888.initial_effect(c)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52253888,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c52253888.atkcon1)
	e1:SetTarget(c52253888.atktg)
	e1:SetOperation(c52253888.atkop)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(52253888,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c52253888.damcon)
	e2:SetTarget(c52253888.damtg)
	e2:SetOperation(c52253888.damop)
	c:RegisterEffect(e2)
end
function c52253888.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c52253888.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,7,nil)
end
function c52253888.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp)) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetCondition(c52253888.atkcon2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e2:SetValue(c52253888.atklimit)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c52253888.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c52253888.atklimit(e,c)
	return c==e:GetOwner()
end
function c52253888.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsPosition(POS_FACEUP_ATTACK) and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c52253888.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=math.ceil(e:GetHandler():GetBattleTarget():GetBaseAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c52253888.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if Duel.NegateAttack() and bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Damage(1-tp,math.ceil(bc:GetBaseAttack()/2),REASON_EFFECT)
	end
end
