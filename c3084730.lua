--昆虫機甲鎧
function c3084730.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3084730,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,3084730)
	e1:SetCondition(c3084730.sscon)
	e1:SetTarget(c3084730.eqtg)
	e1:SetOperation(c3084730.eqop)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c3084730.condition)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
end
function c3084730.sfilter(c)
	return c:IsCode(3084730) and c:IsFaceup()
end
function c3084730.sscon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c3084730.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c3084730.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c3084730.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c3084730.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(c3084730.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c3084730.filter,tp,LOCATION_MZONE,0,1,1,c)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,0,0,0)
	end
end
function c3084730.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown()
		or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c3084730.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c3084730.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c3084730.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
