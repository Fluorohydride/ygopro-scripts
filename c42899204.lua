--死配の呪眼
function c42899204.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c42899204.target)
	e1:SetOperation(c42899204.activate)
	c:RegisterEffect(e1)
	--setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c42899204.setcon)
	e3:SetTarget(aux.ctg)
	e3:SetValue(0x129)
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
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(c42899204.ctval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetCondition(c42899204.con)
		tc:RegisterEffect(e1,true)
	end
end
function c42899204.con(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	return c:IsHasCardTarget(h) and not h:IsImmuneToEffect(e)
end
function c42899204.ctval(e,c)
	return e:GetOwnerPlayer()
end
function c42899204.filter2(c)
	return c:IsCode(44133040) and c:IsFaceup()
end
function c42899204.setcon(e)
	return Duel.IsExistingMatchingCard(c42899204.filter2,e:GetOwnerPlayer(),LOCATION_SZONE,0,1,nil)
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
