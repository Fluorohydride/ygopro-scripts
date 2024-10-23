--ダイガスタ・ラプラムピリカ
function c76937326.initial_effect(c)
	c:SetSPSummonOnce(76937326)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x10),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76937326,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c76937326.spcon)
	e1:SetTarget(c76937326.sptg)
	e1:SetOperation(c76937326.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c76937326.imval)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c76937326.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c76937326.spfilter(c,e,tp)
	return c:IsSetCard(0x10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76937326.fselect(g,tp)
	return g:GetClassCount(Card.GetLocation)==#g and Duel.IsExistingMatchingCard(c76937326.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c76937326.synfilter(c,g)
	return c:IsSetCard(0x10) and c:IsSynchroSummonable(nil,g)
end
function c76937326.chkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x10) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c76937326.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return false end
		local cg=Duel.GetMatchingGroup(c76937326.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(c76937326.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		return g:CheckSubGroup(c76937326.fselect,2,2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c76937326.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local cg=Duel.GetMatchingGroup(c76937326.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg>0 then
			local g=Duel.GetMatchingGroup(c76937326.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,c76937326.fselect,false,2,2,tp)
			if sg then
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
				if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
				local tg=Duel.GetMatchingGroup(c76937326.synfilter,tp,LOCATION_EXTRA,0,nil,og)
				if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local rg=tg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
				end
			end
		end
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c76937326.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c76937326.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c76937326.imval(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x10) and c:IsType(TYPE_SYNCHRO)
end
