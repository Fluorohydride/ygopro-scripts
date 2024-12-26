--ZW－天風精霊翼
---@param c Card
function c95886782.initial_effect(c)
	c:SetUniqueOnField(1,0,95886782)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95886782,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(c95886782.eqcon)
	e1:SetTarget(c95886782.eqtg)
	e1:SetOperation(c95886782.eqop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95886782,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c95886782.atkcon)
	e2:SetOperation(c95886782.atkop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95886782,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c95886782.repcon)
	e3:SetOperation(c95886782.repop)
	c:RegisterEffect(e3)
end
function c95886782.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c95886782.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c95886782.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95886782.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c95886782.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c95886782.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95886782.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	c95886782.zw_equip_monster(c,tp,tc)
end
function c95886782.zw_equip_monster(c,tp,tc)
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c95886782.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c95886782.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c95886782.cfilter(c,e,tp)
	local se,sp=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT,SUMMON_INFO_REASON_PLAYER)
	return se and sp==1-tp and se:IsActivated() and e:GetOwnerPlayer()==1-se:GetOwnerPlayer()
end
function c95886782.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
		and eg:IsExists(c95886782.cfilter,1,nil,e,tp)
end
function c95886782.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e1)
end
function c95886782.repcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1
		and e:GetHandler():GetEquipTarget()==re:GetHandler() and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer()
end
function c95886782.repop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
