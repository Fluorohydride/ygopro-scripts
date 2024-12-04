--アクセルシンクロ・スターダスト・ドラゴン
function c30983281.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30983281,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,30983281)
	e1:SetCondition(c30983281.spcon)
	e1:SetTarget(c30983281.sptg)
	e1:SetOperation(c30983281.spop)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30983281,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,30983282)
	e2:SetCondition(c30983281.sccon)
	e2:SetCost(c30983281.sccost)
	e2:SetTarget(c30983281.sctg)
	e2:SetOperation(c30983281.scop)
	c:RegisterEffect(e2)
end
function c30983281.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c30983281.spfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30983281.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30983281.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c30983281.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30983281.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c30983281.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c30983281.excostfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(84012625,tp)
end
function c30983281.synfilter(c,tp,g)
	return c:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,c)
end
function c30983281.syncheck(g,tp,exc)
	return Duel.IsExistingMatchingCard(c30983281.synfilter,tp,LOCATION_EXTRA,0,1,exc,tp,g)
end
function c30983281.spcheck(c,tp,rc,mg,opchk)
	return Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
		and (opchk or mg:CheckSubGroup(c30983281.syncheck,2,#mg,tp,c))
end
function c30983281.scfilter(c,e,tp,rc,chkrel,chknotrel,tgchk,opchk)
	if not (c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)) then return false end
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	mg:AddCard(c)
	if tgchk then
		return c30983281.spcheck(c,tp,nil,mg,opchk)
	else
		return (chkrel and c30983281.spcheck(c,tp,rc,mg-rc)) or (chknotrel and c30983281.spcheck(c,tp,nil,mg))
	end
end
function c30983281.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	local g=Duel.GetMatchingGroup(c30983281.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local chkrel=c:IsReleasable()
	local chknotrel=g:GetCount()>0
	local b1=chkrel and Duel.IsExistingMatchingCard(c30983281.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,chkrel,nil)
	local b2=chknotrel and Duel.IsExistingMatchingCard(c30983281.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,chknotrel)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (not ect1 or ect1>1) and (not ect2 or ect2>1) and (b1 or b2)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	local rg=Group.CreateGroup()
	local rc=nil
	if b1 then rg:AddCard(c) end
	if b2 then rg:Merge(g) end
	if rg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84012625,0))
		rc=rg:Select(tp,1,1,nil):GetFirst()
	else
		rc=rg:GetFirst()
	end
	local te=rc:IsHasEffect(84012625,tp)
	if te then
		Duel.Remove(rc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(rc,REASON_COST)
	end
end
function c30983281.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsCostChecked() then return true end
		local c=e:GetHandler()
		local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
			and aux.ExtraDeckSummonCountLimit[tp]
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and (not ect1 or ect1>1) and (not ect2 or ect2>1)
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and Duel.IsExistingMatchingCard(c30983281.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,nil,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30983281.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30983281.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,nil,nil,true,true)
	local tc=g:GetFirst()
	local res=false
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(30983281,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c30983281.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1,true)
			tc:CompleteProcedure()
			res=true
		end
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	local tg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if res and tg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(30983281,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c30983281.immval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		sg:GetFirst():RegisterEffect(e1,true)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function c30983281.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActivated()
end
