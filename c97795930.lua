--幻煌龍の天渦
function c97795930.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c97795930.target)
	e1:SetOperation(c97795930.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c97795930.handcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c97795930.reptg)
	e3:SetValue(c97795930.repval)
	e3:SetOperation(c97795930.repop)
	c:RegisterEffect(e3)
end
function c97795930.filter(c)
	return c:IsFaceup() and c:IsCode(56649609)
end
function c97795930.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c97795930.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97795930.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c97795930.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c97795930.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetFlagEffect(97795931)>0 then return end
	tc:RegisterFlagEffect(97795931,RESET_EVENT+RESETS_STANDARD,0,0)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(c97795930.wincon)
		e1:SetOperation(c97795930.winop)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c97795930.winfilter(c)
	return c:IsSetCard(0xfa) and c:IsType(TYPE_EQUIP)
end
function c97795930.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c97795930.winfilter,nil)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and g:GetClassCount(Card.GetCode)>2 and c:GetBattleTarget():IsType(TYPE_EFFECT)
		and c:GetControler()==e:GetOwnerPlayer()
end
function c97795930.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(97795930,RESET_EVENT+RESETS_STANDARD,0,0)
	if c:GetFlagEffect(97795930)>2 then
		local WIN_REASON_CELESTIAL_WHIRLPOOL=0x1c
		Duel.Win(tp,WIN_REASON_CELESTIAL_WHIRLPOOL)
	end
end
function c97795930.handcon(e)
	return Duel.IsEnvironment(22702055)
end
function c97795930.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c97795930.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c97795930.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c97795930.repval(e,c)
	return c97795930.repfilter(c,e:GetHandlerPlayer())
end
function c97795930.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
