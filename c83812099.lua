--フリントロック
function c83812099.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83812099,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c83812099.eqcon1)
	e1:SetTarget(c83812099.eqtg1)
	e1:SetOperation(c83812099.eqop1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83812099,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c83812099.eqcon2)
	e2:SetTarget(c83812099.eqtg2)
	e2:SetOperation(c83812099.eqop2)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c83812099.eqcon2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c83812099.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,75560629)
end
function c83812099.filter1(c,ec)
	return c:IsFaceup() and c:IsCode(75560629) and c:CheckEquipTarget(ec,c:GetControler(),true)
end
function c83812099.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c83812099.filter1(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c83812099.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c83812099.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g:GetFirst(),1,0,0)
end
function c83812099.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Equip(tp,tc,c)
	end
end
function c83812099.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,75560629)
end
function c83812099.eqfilter(c,tp,eqc)
	return c:IsFaceup() and c:IsCode(75560629) and eqc:IsContains(c)
		and Duel.IsExistingTarget(c83812099.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),c)
end
function c83812099.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c,eqc:GetControler(),true)
end
function c83812099.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local eqc=e:GetHandler():GetEquipGroup()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c83812099.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp,eqc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c83812099.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp,eqc)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c83812099.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1:GetFirst(),1,0,0)
end
function c83812099.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and lc:IsRelateToEffect(e) and lc:IsFaceup() then
		Duel.Equip(tp,tc,lc)
	end
end
