--閃刀起動－リンケージ
function c9726840.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9726840.condition)
	e1:SetTarget(c9726840.target)
	e1:SetOperation(c9726840.activate)
	c:RegisterEffect(e1)
end
function c9726840.cfilter(c)
	return c:GetSequence()<5
end
function c9726840.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9726840.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--send to grave filter before activation
function c9726840.tgfilter1(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c9726840.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9726840.spfilter1(c,e,tp,mc)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c,0x60)>0
end
function c9726840.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9726840.tgfilter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--send to grave filter after activation
function c9726840.tgfilter2(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c9726840.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9726840.exfilter(c,e,tp,mc)
	return c:IsSetCard(0x1115) and Duel.GetLocationCountFromEx(tp,tp,mc,c,0x60)>0
end
function c9726840.spfilter2(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,0x60)
end
function c9726840.tgfilter3(c,tp)
	return c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,c,nil,0x60)>0
end
function c9726840.tgfilter4(c)
	return c:IsAbleToGrave()
end
function c9726840.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg2=Duel.GetMatchingGroup(c9726840.tgfilter2,tp,LOCATION_ONFIELD,0,c,e,tp)
	local tg3=(#tg2==0) and Duel.GetMatchingGroup(c9726840.tgfilter3,tp,LOCATION_ONFIELD,0,c,tp) or nil
	local tg4=(tg3 and #tg3==0) and Duel.GetMatchingGroup(c9726840.tgfilter4,tp,LOCATION_ONFIELD,0,c) or nil
	if #tg2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=tg2:Select(tp,1,1,c):GetFirst()
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c9726840.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,0x60)
				local fg=Duel.GetMatchingGroup(c9726840.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
				if fg:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(1000)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
			end
		end
	elseif tg3 and #tg3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=tg3:Select(tp,1,1,c):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	elseif tg4 and #tg4>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=tg4:Select(tp,1,1,c):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9726840.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9726840.atkfilter(c)
	return c:IsSetCard(0x1115) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c9726840.splimit(e,c)
	return not c:IsSetCard(0x1115) and c:IsLocation(LOCATION_EXTRA)
end
