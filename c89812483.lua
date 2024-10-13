--メタル化・強化反射装甲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89812483)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.filter1(c,e,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,1,c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function s.filter2(c,e,tp,ft,lv,race,att)
	return not c:IsSummonableCard() and aux.IsCodeListed(c,89812483) and c:IsType(TYPE_MONSTER)
		and (not c:IsLocation(LOCATION_DECK+LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
		or c.Metallization_material and c.Metallization_material(ft,lv,race,att) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,0) end
		return e:IsCostChecked() and Duel.CheckReleaseGroup(tp,s.filter1,1,nil,e,tp)
	end
	if e:GetLabel()==1 then
		local rg=Duel.SelectReleaseGroup(tp,s.filter1,1,1,nil,e,tp)
		local ec=rg:GetFirst()
		e:SetLabel(1,ec:GetLevel(),ec:GetRace(),ec:GetAttribute())
		Duel.Release(ec,REASON_COST)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)>0 then
		tc:CompleteProcedure()
		if c:IsOnField() and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			c:CancelToGrave(true)
			if Duel.Equip(tp,c,tc)~=0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				c:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(400)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_EQUIP)
				e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e4:SetValue(s.efilter)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e4)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e5:SetValue(s.tgval)
				c:RegisterEffect(e5)
			else
				c:CancelToGrave(false)
			end
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL) and rp==1-e:GetHandlerPlayer()
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL)
end
