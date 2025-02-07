--ドライブレイブ
function c78161361.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(78161361,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c78161361.atkcon)
	e1:SetCost(c78161361.atkcost)
	e1:SetTarget(c78161361.atktg)
	e1:SetOperation(c78161361.atkop)
	c:RegisterEffect(e1)
end
function c78161361.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and a:IsRace(RACE_CYBERSE)
end
function c78161361.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c78161361.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78161361.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c78161361.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c78161361.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttacker():CreateEffectRelation(e)
end
function c78161361.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToEffect(e) and a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
	end
end
