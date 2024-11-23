--ドラグニティ・ドライブ
---@param c Card
function c28927782.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,28927782)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c28927782.eftg)
	e2:SetOperation(c28927782.efop)
	c:RegisterEffect(e2)
end
function c28927782.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x29) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28927782.eqfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x29) and Duel.IsExistingMatchingCard(c28927782.eqfilter2,tp,LOCATION_GRAVE,0,1,nil,c,tp)
end
function c28927782.eqfilter2(c,tc,tp)
	return c:IsSetCard(0x29) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c28927782.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c28927782.spfilter(chkc,e,tp)
		else return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28927782.eqfilter1(chkc,tp) end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c28927782.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c28927782.eqfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(28927782,1),aux.Stringid(28927782,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(28927782,1))
	else op=Duel.SelectOption(tp,aux.Stringid(28927782,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c28927782.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c28927782.eqfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function c28927782.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local ec=Duel.GetFirstTarget()
		if ec:IsRelateToEffect(e) and ec:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28927782.eqfilter2),tp,LOCATION_GRAVE,0,1,1,nil,ec,tp)
			local tc=g:GetFirst()
			if not tc or not Duel.Equip(tp,tc,ec) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c28927782.eqlimit2)
			e1:SetLabelObject(ec)
			tc:RegisterEffect(e1)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c28927782.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c28927782.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x29)
end
function c28927782.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
