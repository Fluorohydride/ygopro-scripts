--鋼核収納
function c20457551.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c20457551.target)
	e1:SetOperation(c20457551.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c20457551.eqlimit)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c20457551.atkcon)
	e3:SetTarget(c20457551.atktg)
	e3:SetValue(c20457551.atkval)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c20457551.desreptg)
	c:RegisterEffect(e4)
end
function c20457551.eqlimit(e,c)
	return c:IsSetCard(0x1d)
end
function c20457551.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d)
end
function c20457551.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20457551.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20457551.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20457551.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20457551.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c20457551.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler():GetEquipTarget():GetBattleTarget()
end
function c20457551.atktg(e,c)
	return c==e:GetHandler():GetEquipTarget():GetBattleTarget()
end
function c20457551.atkval(e,c)
	return e:GetHandler():GetEquipTarget():GetLevel()*-100
end
function c20457551.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_END and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		return true
	else return false end
end
