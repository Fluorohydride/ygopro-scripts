--巳剣降臨
local s,id,o=GetID()
function s.initial_effect(c)
	--select effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_REPTILE)
end
function s.mfilter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_REPTILE) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.rcheck(tp,g,c)
	return g:GetCount()<3
end
function s.rgcheck(g,ec)
	return g:GetCount()<3
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_REPTILE)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	local s1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,s.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local s2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,s.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local b1=s1 and (Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked())
	local b2=s2 and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	if op==1 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:SetOperation(s.spop1)
	elseif op==2 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		e:SetOperation(s.spop2)
	end
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	::cancel1::
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_REPTILE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,s.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel1 end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	::cancel2::
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_REPTILE)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,s.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto cancel2
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
