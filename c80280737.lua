--バスター・モード
function c80280737.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c80280737.target)
	e1:SetOperation(c80280737.activate)
	c:RegisterEffect(e1)
end
function c80280737.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c80280737.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c80280737.filter2(c,e,tp,tcode)
	return c:IsSetCard(0x104f) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_ATTACK)
end
function c80280737.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,false):Filter(c80280737.filter1,nil,e,tp)
	if Duel.GetFlagEffect(tp,91002901)>Duel.GetFlagEffect(tp,80280737) then
		g:Merge(Duel.GetMatchingGroup(c80280737.filter1,tp,LOCATION_EXTRA,0,nil,e,tp))
	end
	if chk==0 then return e:IsCostChecked() and g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	if rg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		Duel.Hint(HINT_CARD,0,91002901)
		Duel.RegisterFlagEffect(tp,80280737,RESET_PHASE+PHASE_END,0,1)
	end
	aux.UseExtraReleaseCount(rg,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80280737.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c80280737.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end
