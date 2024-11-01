--分かつ烙印
---@param c Card
function c1041278.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1041278+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c1041278.cost)
	e1:SetTarget(c1041278.target)
	e1:SetOperation(c1041278.activate)
	c:RegisterEffect(e1)
end
function c1041278.rfilter1(c,tp)
	return c:IsType(TYPE_FUSION) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function c1041278.rfilter2(c,tp)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.GetMZoneCount(tp,c)>1
end
function c1041278.spfilter0(c,e,tp)
	return not c:IsType(TYPE_FUSION) and c:IsFaceupEx() and c:IsCanBeEffectTarget(e)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function c1041278.spfilter1(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and g:IsExists(c1041278.spfilter2,1,c,e,tp)
end
function c1041278.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c1041278.spfilter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c1041278.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1041278.spfilter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	local b1=Duel.CheckReleaseGroup(tp,c1041278.rfilter1,1,nil,tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and g:IsExists(c1041278.spfilter1,1,nil,e,tp,g)
	local b2=Duel.CheckReleaseGroup(tp,c1041278.rfilter2,1,nil,tp)
		and g:IsExists(c1041278.spfilter3,2,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local rfilter=c1041278.rfilter1
	if b2 and not b1 then
		rfilter=c1041278.rfilter2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,rfilter,1,1,nil,tp)
	local rc=rg:GetFirst()
	e:SetLabelObject(rc)
	Duel.Release(rg,REASON_COST)
end
function c1041278.gcheck(g,e,tp,b1,b2)
	return b1 and g:IsExists(c1041278.spfilter1,1,nil,e,tp,g)
		or b2 and g:IsExists(c1041278.spfilter3,2,nil,e,tp)
end
function c1041278.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	local g=Duel.GetMatchingGroup(c1041278.spfilter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	local b1=ft1>0 and ft2>0
		and g:IsExists(c1041278.spfilter1,1,nil,e,tp,g)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and (b1 or e:IsCostChecked()) end
	local check=e:IsCostChecked() and aux.IsMaterialListCode(e:GetLabelObject(),68468459)
	e:SetLabel(check and 1 or 0)
	local b2=check and ft1>1
		and g:IsExists(c1041278.spfilter3,2,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c1041278.gcheck,false,2,2,e,tp,b1,b2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
end
function c1041278.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 and ft2<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()==2 then
		local b1=ft1>0 and ft2>0
			and g:IsExists(c1041278.spfilter1,1,nil,e,tp,g)
		local b2=e:GetLabel()~=0 and ft1>1
			and g:IsExists(c1041278.spfilter3,2,nil,e,tp)
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(1041278,0))) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1041278,1))
			local sg=g:FilterSelect(tp,c1041278.spfilter1,1,1,nil,e,tp,g)
			if #sg==0 then return end
			Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonStep((g-sg):GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		end
	end
end
