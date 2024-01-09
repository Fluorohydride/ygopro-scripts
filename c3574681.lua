--金科玉条
function c3574681.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,3574681+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c3574681.target)
	e1:SetOperation(c3574681.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c3574681.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c3574681.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c3574681.filter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c3574681.spfilter(c,e,tp,code1,code2)
	return not c:IsCode(code1,code2) and c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3574681.gcheck(g,e,tp)
	if #g~=2 then return false end
	local a=g:GetFirst()
	local d=g:GetNext()
	return Duel.IsExistingMatchingCard(c3574681.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,a:GetCode(),d:GetCode())
end
function c3574681.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c3574681.filter,tp,LOCATION_DECK,0,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	if chk==0 then return ft>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(c3574681.gcheck,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c3574681.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c3574681.filter,tp,LOCATION_DECK,0,nil)
	if ft>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:SelectSubGroup(tp,c3574681.gcheck,false,2,2,e,tp)
		if not sg then return end
		local ac=sg:GetFirst()
		local bc=sg:GetNext()
		if Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			and Duel.MoveToField(bc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			ac:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			bc:RegisterEffect(e2)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c3574681.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,ac:GetCode(),bc:GetCode())
			if #rg==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=rg:Select(tp,1,1,nil):GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				Duel.Equip(tp,c,tc)
				--Add Equip limit
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c3574681.eqlimit)
				c:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c3574681.eqlimit(e,c)
	return e:GetOwner()==c
end
function c3574681.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c3574681.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
