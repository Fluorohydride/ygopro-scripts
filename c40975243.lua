--鉄獣の抗戦
function c40975243.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40975243+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c40975243.target)
	e1:SetOperation(c40975243.activate)
	c:RegisterEffect(e1)
end
function c40975243.spfilter(c,e,tp)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c40975243.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c40975243.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c40975243.lkfilter(c,g)
	return c:IsSetCard(0x14d) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c40975243.chkfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x14d) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c40975243.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local cg=Duel.GetMatchingGroup(c40975243.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local _,maxlink=cg:GetMaxGroup(Card.GetLink)
		if maxlink>ft then maxlink=ft end
		local g=Duel.GetMatchingGroup(c40975243.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		return g:CheckSubGroup(c40975243.fselect,1,maxlink,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c40975243.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40975243.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local cg=Duel.GetMatchingGroup(c40975243.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local _,maxlink=cg:GetMaxGroup(Card.GetLink)
	if ft>0 and maxlink then
		if maxlink>ft then maxlink=ft end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c40975243.fselect,false,1,maxlink,tp)
		if not sg then return end
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
		local tg=Duel.GetMatchingGroup(c40975243.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
		end
	end
end
