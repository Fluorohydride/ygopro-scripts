--セレンの呪眼
function c44133040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c44133040.target)
	e1:SetOperation(c44133040.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c44133040.eqlimit)
	c:RegisterEffect(e2)
	--indes/cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(44133040,0))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c44133040.atkcon)
	e7:SetOperation(c44133040.atkop)
	c:RegisterEffect(e7)
	--set
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(44133040,1))
	e8:SetCategory(CATEGORY_SSET)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,52840268)
	e8:SetCost(c44133040.setcost)
	e8:SetTarget(c44133040.settg)
	e8:SetOperation(c44133040.setop)
	c:RegisterEffect(e8)
end
function c44133040.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x129)
end
function c44133040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44133040.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44133040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c44133040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c44133040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c44133040.eqlimit(e,c)
	return c:IsSetCard(0x129)
end
function c44133040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rp==tp
		and ((re:IsActiveType(TYPE_MONSTER) and c:GetEquipTarget()==rc)
			or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x129) and rc~=c))
end
function c44133040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
	end
end
function c44133040.costfilter(c)
	return c:IsSetCard(0x129) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(44133040) and c:IsAbleToRemoveAsCost()
end
function c44133040.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c44133040.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c44133040.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c44133040.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c44133040.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
