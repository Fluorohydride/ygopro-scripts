--鎖付き真紅眼牙
function c57135971.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c57135971.target)
	e1:SetOperation(c57135971.operation)
	c:RegisterEffect(e1)
	--sand to grave and equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c57135971.descon)
	e2:SetCost(c57135971.descost)
	e2:SetTarget(c57135971.destg)
	e2:SetOperation(c57135971.desop)
	c:RegisterEffect(e2)
end
function c57135971.filter(c)
	return c:IsSetCard(0x3b) and c:IsFaceup()
end
function c57135971.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c57135971.filter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c57135971.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c57135971.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c57135971.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Equip limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(c57135971.eqlimit)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end
function c57135971.eqlimit(e,c)
	return c:IsSetCard(0x3b)
end
function c57135971.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c57135971.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabelObject(e:GetHandler():GetEquipTarget())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c57135971.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c57135971.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c57135971.desfilter(chkc) and chkc~=tc end
	if chk==0 then return Duel.IsExistingTarget(c57135971.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler():GetEquipTarget()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c57135971.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c57135971.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--Atk
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetValue(c:GetDefense())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Equip limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(c57135971.eqlimit2)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetLabelObject(tc)
		c:RegisterEffect(e3)
	end
end
function c57135971.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
