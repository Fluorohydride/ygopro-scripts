--優麗なる霊鏡
function c18954366.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18954366+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c18954366.target)
	e1:SetOperation(c18954366.activate)
	c:RegisterEffect(e1)
end
function c18954366.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18954366.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
		and Duel.IsExistingMatchingCard(c18954366.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetLevel())
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c18954366.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc:IsType(TYPE_MONSTER) and chkc:IsLevelBelow(4) end
	local ft=1
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=2 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>=ft
		and Duel.IsExistingTarget(c18954366.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c18954366.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c18954366.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=tc:GetLevel()
	local atk=tc:GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c18954366.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0
		and not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
		and Duel.Equip(tp,tc,sc) then
		if atk>0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_EQUIP)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.ceil(atk/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(c18954366.aclimit)
		e2:SetLabel(tc:GetCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--equip limit
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(sc)
		e3:SetValue(c18954366.eqlimit)
		tc:RegisterEffect(e3)
	end
end
function c18954366.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c18954366.eqlimit(e,c)
	return c==e:GetLabelObject()
end
