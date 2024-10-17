--ZW－天馬双翼剣
---@param c Card
function c32164201.initial_effect(c)
	c:SetUniqueOnField(1,0,32164201)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c32164201.spcon)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32164201,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c32164201.eqcon)
	e2:SetTarget(c32164201.eqtg)
	e2:SetOperation(c32164201.eqop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c32164201.negcon)
	e3:SetOperation(c32164201.negop)
	c:RegisterEffect(e3)
end
function c32164201.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-2000
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c32164201.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c32164201.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c32164201.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c32164201.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c32164201.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c32164201.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c32164201.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	c32164201.zw_equip_monster(c,tp,tc)
end
function c32164201.zw_equip_monster(c,tp,tc)
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c32164201.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--Gains ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c32164201.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c32164201.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and c:GetFlagEffect(32164201)==0
end
function c32164201.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(32164201,1)) then
		Duel.Hint(HINT_CARD,0,32164201)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(32164201,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
