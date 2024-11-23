--斬機超階乗
---@param c Card
function c87804365.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87804365+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c87804365.target)
	e1:SetOperation(c87804365.activate)
	c:RegisterEffect(e1)
end
function c87804365.spfilter1(c,e,tp)
	return c:IsSetCard(0x132) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c87804365.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(c87804365.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c87804365.synfilter(c,g)
	return c:IsSetCard(0x132) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c87804365.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(c87804365.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c87804365.xyzfilter(c,g)
	return c:IsSetCard(0x132) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c87804365.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(c87804365.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=g:CheckSubGroup(c87804365.fselect1,1,ft,tp)
	local b2=g:CheckSubGroup(c87804365.fselect2,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(87804365,0),aux.Stringid(87804365,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(87804365,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(87804365,1))+1
	end
	e:SetLabel(op)
	local sg=nil
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c87804365.fselect1,false,1,ft,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c87804365.fselect2,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c87804365.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87804365.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c87804365.spfilter2,nil,e,tp)
	if #g==0 then return end
	if #g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local tc=g:GetFirst()
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
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	if op==0 then
		local tg=Duel.GetMatchingGroup(c87804365.synfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			local tc=og:GetFirst()
			while tc do
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(LOCATION_DECKBOT)
				tc:RegisterEffect(e3)
				tc=og:GetNext()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
		end
	else
		local tg=Duel.GetMatchingGroup(c87804365.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
		end
	end
end
