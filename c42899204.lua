--死配の呪眼
---@param c Card
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
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TARGET)
	e2:SetCode(EFFECT_SET_CONTROL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c42899204.ctval)
	c:RegisterEffect(e2)
	--setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TARGET)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c42899204.setcon)
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
function c42899204.filter1(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsAttackPos() and c:IsControler(1-tp)
		and Duel.IsExistingMatchingCard(c42899204.filter,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c42899204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c42899204.filter1(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c42899204.filter1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=eg:FilterSelect(tp,c42899204.filter1,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c42899204.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c42899204.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c42899204.filter2(c)
	return c:IsCode(44133040) and c:IsFaceup()
end
function c42899204.setcon(e)
	return Duel.IsExistingMatchingCard(c42899204.filter2,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
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
