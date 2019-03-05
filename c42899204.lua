--死配の呪眼
function c42899204.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c42899204.target)
	e1:SetOperation(c42899204.activate)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(c42899204.tgcon)
	e2:SetOperation(c42899204.tgop)
	c:RegisterEffect(e2)
	--setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(0x129)
	e3:SetTarget(c42899204.distg)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c42899204.descon)
	e4:SetOperation(c42899204.desop)
	c:RegisterEffect(e4)
end
function c42899204.filter(c,atk)
	return c:IsSetCard(0x129) and c:IsFaceup() and c:GetAttack()>atk
end
function c42899204.filter1(c,tp)
	return c:IsAttackPos() and c:IsControler(1-tp)
		and Duel.IsExistingMatchingCard(c42899204.filter,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c42899204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c42899204.filter1(chkc,tp) end
	if chk==0 then return eg:IsExists(c42899204.filter1,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=eg:FilterSelect(tp,c42899204.filter1,1,1,nil,tp):GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c42899204.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
function c42899204.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c42899204.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c42899204.filter2(c)
	return c:IsCode(44133040) and c:IsFaceup()
end
function c42899204.distg(e,c)
	return e:GetHandler():IsHasCardTarget(c) and Duel.IsExistingMatchingCard(c42899204.filter2,tp,LOCATION_SZONE,0,1,nil)
end
function c42899204.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c42899204.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
