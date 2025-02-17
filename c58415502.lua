--ロイヤル・ストレート
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCode(25652259,64788463,90876561) and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp,g)
	if not (aux.IsCodeListed(c,25652259) and aux.IsCodeListed(c,64788463) and aux.IsCodeListed(c,90876561)) then return false end
	local proc=c:IsCode(11020863) and e:GetHandler():IsCode(id)
	if not c:IsCanBeSpecialSummoned(e,0,tp,proc,proc) then return false end
	return (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,g)>0
		or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0)
end
function s.fgoal(g,e,tp)
	return aux.dncheck(g) and Duel.IsExistingMatchingCard(s.spfilter,tp,
		LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,g)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(s.fgoal,3,3,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,
		LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if sg and Duel.SendtoGrave(sg,REASON_EFFECT)>0 and sg:IsExists(Card.IsLocation,3,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,
			LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
			local proc=tc:IsCode(11020863) and e:GetHandler():IsCode(id)
			Duel.SpecialSummon(tc,0,tp,tp,proc,proc,POS_FACEUP)
			if proc then tc:CompleteProcedure() end
		end
	end
end
