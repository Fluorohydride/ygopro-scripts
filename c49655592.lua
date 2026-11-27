--F.A.ウィップクロッサー
function c49655592.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c49655592.atkval)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c49655592.costchk)
	e2:SetTarget(c49655592.costtg)
	e2:SetOperation(c49655592.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLAG_EFFECT+49655592)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	--lv up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49655592,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(c49655592.lvcon)
	e4:SetOperation(c49655592.lvop)
	c:RegisterEffect(e4)
	--discard limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCode(EFFECT_CANNOT_DISCARD_HAND)
	e5:SetCondition(c49655592.excon)
	e5:SetTarget(c49655592.extarget)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_HAND)
	e6:SetCondition(c49655592.excon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c49655592.atkval(e,c)
	return c:GetLevel()*300
end
function c49655592.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x107)
end
function c49655592.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c49655592.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,49655592)
	return Duel.CheckLPCost(tp,ct*300)
end
function c49655592.costtg(e,te,tp)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	local tc=te:GetHandler()
	local lv=e:GetHandler():GetLevel()
	if tc:GetRank()>0 then
		return tc:GetOriginalRank()<lv
	elseif tc:GetLevel()>0 then
		return tc:GetOriginalLevel()<lv
	else return false end
end
function c49655592.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end
function c49655592.excon(e)
	return e:GetHandler():IsLevelAbove(7)
end
function c49655592.extarget(e,dc,re,r)
	return r&REASON_COST==REASON_COST
end
