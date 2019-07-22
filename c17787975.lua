--ディメンション・スフィンクス
function c17787975.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c17787975.target)
	e1:SetOperation(c17787975.tgop)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17787975,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(TIMING_BATTLE_PHASE)
	e3:SetCondition(c17787975.damcon)
	e3:SetTarget(c17787975.damtg)
	e3:SetOperation(c17787975.damop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c17787975.descon)
	e4:SetOperation(c17787975.desop)
	c:RegisterEffect(e4)
end
function c17787975.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c17787975.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17787975.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17787975.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17787975.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c17787975.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c17787975.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP
end
function c17787975.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local at=Duel.GetAttacker()
	if chk==0 then return tc and Duel.GetAttackTarget()==tc
		and at and at:IsControler(1-tp) and at:GetAttack()>tc:GetAttack()
		and c:GetFlagEffect(17787975)==0 end
	local dam=math.abs(at:GetAttack()-tc:GetAttack())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	c:RegisterFlagEffect(17787975,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c17787975.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local at=Duel.GetAttacker()
	if at:IsRelateToBattle() then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,math.abs(at:GetAttack()-tc:GetAttack()),REASON_EFFECT)
	end
end
function c17787975.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c17787975.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
