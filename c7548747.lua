--大いなる魔導
---@param c Card
function c7548747.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,7548747+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7548747.target)
	e1:SetOperation(c7548747.activate)
	c:RegisterEffect(e1)
end
function c7548747.filter(c,tp,check)
	return c:IsFaceup() and c:IsSetCard(0x150) and Duel.IsExistingMatchingCard(c7548747.eqfilter,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,0,1,c,check)
end
function c7548747.eqfilter(c,check)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and not c:IsLevel(4)
		or check and c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x150) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c7548747.gfilter(c,type)
	return c:IsSetCard(0x150) and c:IsType(type)
end
function c7548747.check(tp,type)
	return Duel.IsExistingMatchingCard(c7548747.gfilter,tp,LOCATION_GRAVE,0,1,nil,type)
end
function c7548747.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=c7548747.check(tp,TYPE_FUSION) and c7548747.check(tp,TYPE_SYNCHRO) and c7548747.check(tp,TYPE_XYZ) and c7548747.check(tp,TYPE_LINK)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7548747.filter(chkc,tp,check) end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if b then ft=ft-1 end
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c7548747.filter,tp,LOCATION_MZONE,0,1,nil,tp,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c7548747.filter,tp,LOCATION_MZONE,0,1,1,nil,tp,check)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE)
end
function c7548747.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local check=c7548747.check(tp,TYPE_FUSION) and c7548747.check(tp,TYPE_SYNCHRO) and c7548747.check(tp,TYPE_XYZ) and c7548747.check(tp,TYPE_LINK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c7548747.eqfilter),tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,check)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(c7548747.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function c7548747.eqlimit(e,c)
	return c==e:GetLabelObject()
end
