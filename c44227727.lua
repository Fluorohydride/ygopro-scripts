--海造賊－進水式
function c44227727.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND))
	e1:SetDescription(aux.Stringid(44227727,0))
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44227727,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,44227727)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c44227727.eqtg)
	e2:SetOperation(c44227727.eqop)
	c:RegisterEffect(e2)
end
function c44227727.eqfilter(c,ec,tp)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x13f) or c:IsCode(80621422) and c:CheckEquipTarget(ec))
		and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c44227727.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x13f) and Duel.IsExistingMatchingCard(c44227727.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c44227727.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c44227727.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c44227727.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c44227727.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c44227727.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c44227727.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c44227727.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c44227727.eqlimit(e,c)
	return c==e:GetLabelObject()
end
