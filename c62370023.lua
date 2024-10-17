--スノーマン・エフェクト
---@param c Card
function c62370023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62370023+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c62370023.target)
	e1:SetOperation(c62370023.activate)
	c:RegisterEffect(e1)
	if not c62370023.global_check then
		c62370023.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c62370023.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c62370023.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(62370023)==0 and Duel.GetAttackTarget()==nil then
		tc:RegisterFlagEffect(62370023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c62370023.filter(c,tp)
	return c:IsFaceup() and c:GetFlagEffect(62370023)==0
		and Duel.IsExistingMatchingCard(c62370023.atkfilter,tp,LOCATION_MZONE,0,1,c)
end
function c62370023.atkfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function c62370023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c62370023.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c62370023.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c62370023.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	g:GetFirst():RegisterEffect(e1)
end
function c62370023.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c62370023.atkfilter,tp,LOCATION_MZONE,0,tc)
		local atk=g:GetSum(Card.GetBaseAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
