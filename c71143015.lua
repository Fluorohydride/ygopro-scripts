--究極融合
function c71143015.initial_effect(c)
	aux.AddCodeList(c,89631139,23995346)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,71143015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c71143015.condition)
	e1:SetTarget(c71143015.target)
	e1:SetOperation(c71143015.activate)
	c:RegisterEffect(e1)
end
function c71143015.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c71143015.filter0(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c71143015.filter1(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and (aux.IsMaterialListCode(c,89631139) or aux.IsMaterialListCode(c,23995346)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FGoalCheckAdditional=c.ultimate_fusion_check or c71143015.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FGoalCheckAdditional=nil
	return res
end
function c71143015.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,89631139) and aux.IsMaterialListCode(fc,89631139)
		or sg:IsExists(Card.IsFusionCode,1,nil,23995346) and aux.IsMaterialListCode(fc,23995346)
end
function c71143015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c71143015.filter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c71143015.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c71143015.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71143015.desfilter(c)
	return c:IsFusionCode(89631139,23995346) and c:IsOnField()
end
function c71143015.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71143015.filter0),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c71143015.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ct=0
	local spchk=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c71143015.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FGoalCheckAdditional=tc.ultimate_fusion_check or c71143015.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			ct=mat1:FilterCount(c71143015.desfilter,nil)
			tc:SetMaterial(mat1)
			if mat1:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat1:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat1:Filter(c71143015.cfilter,nil):GetCount()>0 then
				local cg=mat1:Filter(c71143015.cfilter,nil)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			spchk=1
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			ct=mat2:FilterCount(c71143015.desfilter,nil)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			spchk=1
		end
		tc:CompleteProcedure()
	end
	aux.FGoalCheckAdditional=nil
	if ct>0 and spchk>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(71143015,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c71143015.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end

