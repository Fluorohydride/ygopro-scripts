--弱体化の仮面
function c57882509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c57882509.condition)
	e1:SetTarget(c57882509.target)
	e1:SetOperation(c57882509.activate)
	c:RegisterEffect(e1)
end
function c57882509.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c57882509.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetAttacker()
	if chkc then return chkc==tc end
	if chk==0 then return tc and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end
function c57882509.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-700)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
