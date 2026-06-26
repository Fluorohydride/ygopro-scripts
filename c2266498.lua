--ヴェンデット・リユニオン
function c2266498.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2266498.target)
	e1:SetOperation(c2266498.activate)
	c:RegisterEffect(e1)
end
function c2266498.cfilter(c,e,tp,m,ft)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x106) or c:IsPublic()
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil,tp)
	end
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=m:CheckSubGroup(c2266498.fselect,1,math.min(c:GetLevel(),ft),c)
	aux.GCheckAdditional=nil
	return res
end
function c2266498.fselect(g,mc)
	return aux.dncheck(g) and g:CheckWithSumEqual(Card.GetRitualLevel,mc:GetLevel(),g:GetCount(),g:GetCount(),mc)
end
function c2266498.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x106) and Duel.IsPlayerCanRelease(tp,c,REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c2266498.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local mg=Duel.GetMatchingGroup(c2266498.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(c2266498.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c2266498.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c2266498.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c2266498.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	if tg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,tg)
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local sg=mg:SelectSubGroup(tp,c2266498.fselect,false,1,math.min(tc:GetLevel(),ft),tc)
		aux.GCheckAdditional=nil
		if not sg or sg:GetCount()==0 then return end
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)==sg:GetCount() then
			Duel.BreakEffect()
			local og=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,og)
			tc:SetMaterial(og)
			Duel.Release(og,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
