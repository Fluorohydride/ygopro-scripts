--機塊テスト
function c66380357.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,66380357+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c66380357.target)
	e1:SetOperation(c66380357.activate)
	c:RegisterEffect(e1)
end
function c66380357.filter(c,e,tp)
	if not (c:IsType(TYPE_LINK) and c:IsSetCard(0x14b)) then return false end
	local zone=c:GetLinkedZone(tp)
	return Duel.IsExistingMatchingCard(c66380357.gfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
end
function c66380357.gfilter(c,e,tp,zone)
	return c:IsSetCard(0x14b) and c:IsType(TYPE_LINK) and c:IsLink(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c66380357.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66380357.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c66380357.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66380357.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c66380357.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	local upbound=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if upbound<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then upbound=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c66380357.gfilter),tp,LOCATION_GRAVE,0,1,upbound,nil,e,tp,zone)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			tc:RegisterFlagEffect(66380357,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c66380357.rmcon)
		e1:SetOperation(c66380357.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c66380357.rmfilter(c,fid)
	return c:GetFlagEffectLabel(66380357)==fid
end
function c66380357.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c66380357.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c66380357.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c66380357.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
