--天馬の翼
function c72083436.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72083436,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c72083436.dacon)
	e1:SetTarget(c72083436.datg)
	e1:SetOperation(c72083436.daop)
	c:RegisterEffect(e1)
end
c72083436.has_text_type=TYPE_UNION
function c72083436.cfilter(c)
	return c:IsType(TYPE_UNION)
end
function c72083436.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72083436.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsAbleToEnterBP()
end
function c72083436.filter(c)
	return c:IsSetCard(0x122) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c72083436.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c72083436.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72083436.filter,tp,LOCATION_MZONE,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c72083436.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c72083436.filter,tp,LOCATION_MZONE,0,1,ct,nil)
end
function c72083436.dafilter(c,e)
	return not c:IsHasEffect(EFFECT_DIRECT_ATTACK) and c:IsRelateToEffect(e)
end
function c72083436.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c72083436.dafilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetCondition(c72083436.rdcon)
		e2:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(72083436,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c72083436.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and c:GetFlagEffect(72083436)>0
end
