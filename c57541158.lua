--海晶乙女スリーピーメイデン
function c57541158.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57541158,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,57541158)
	e1:SetTarget(c57541158.sptg)
	e1:SetOperation(c57541158.spop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57541158,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,57541159)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c57541158.eqtg)
	e2:SetOperation(c57541158.eqop)
	c:RegisterEffect(e2)
end
function c57541158.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b)
end
function c57541158.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c57541158.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57541158.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c57541158.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c57541158.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_TARGET)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c57541158.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK)
end
function c57541158.eqfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and not c:IsForbidden()
end
function c57541158.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c57541158.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c57541158.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c57541158.eqfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c57541158.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c57541158.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c57541158.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(c57541158.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function c57541158.eqlimit(e,c)
	return c==e:GetLabelObject()
end
