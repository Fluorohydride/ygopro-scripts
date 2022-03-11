--不朽の七皇
function c60158866.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,60158866)
	e2:SetTarget(c60158866.target)
	e2:SetOperation(c60158866.operation)
	c:RegisterEffect(e2)
end
function c60158866.filter(c)
	local no=aux.GetXyzNumber(c)
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function c60158866.cfilter(c)
	if not c:IsType(TYPE_XYZ) then return false end
	if c60158866.filter(c) then return true end
	local g=c:GetOverlayGroup()
	return g:IsExists(c60158866.filter,1,nil)
end
function c60158866.disfilter(c,atk)
	return aux.NegateMonsterFilter(c) and c:IsAttackBelow(atk)
end
function c60158866.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60158866.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60158866.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60158866.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local s=0
	local b1=Duel.IsExistingMatchingCard(c60158866.disfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetAttack())
	local b2=tc:GetOverlayGroup():GetCount()>0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(60158866,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(60158866,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(60158866,0),aux.Stringid(60158866,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c60158866.operation(e,tp,eg,ep,ev,re,r,rp)
	local s=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if s==0 then
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		local sg=Duel.GetMatchingGroup(c60158866.disfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if sc and not sc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
			end
		end
	end
	if s==1 then
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 and Duel.SendtoGrave(og,REASON_EFFECT)>0
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c60158866.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(60158866,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local ng=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60158866.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if ng:GetCount()>0 then
					Duel.BreakEffect()
					Duel.SpecialSummon(ng,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c60158866.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
