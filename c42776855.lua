--追走の翼
function c42776855.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c42776855.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(c42776855.tgcon)
	e2:SetOperation(c42776855.tgop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c42776855.indestg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c42776855.efilter)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(42776855,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c42776855.atkcon)
	e5:SetOperation(c42776855.atkop)
	c:RegisterEffect(e5)
	--Destroy2
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c42776855.descon2)
	e7:SetOperation(c42776855.desop2)
	c:RegisterEffect(e7)
end
function c42776855.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c42776855.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c42776855.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c42776855.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c42776855.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c42776855.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c42776855.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c42776855.indestg(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
function c42776855.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c42776855.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	return tc:IsLocation(LOCATION_MZONE) and bc and bc:IsFaceup() and bc:IsLocation(LOCATION_MZONE) and bc:IsLevelAbove(5)
end
function c42776855.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	local atk=bc:GetBaseAttack()
	if bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 and bc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c42776855.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c42776855.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
