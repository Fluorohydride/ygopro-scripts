--烙印融合
function c44362883.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,44362883+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c44362883.cost)
	e1:SetTarget(c44362883.target)
	e1:SetOperation(c44362883.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(44362883,ACTIVITY_SPSUMMON,c44362883.counterfilter)
end
function c44362883.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function c44362883.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(44362883,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c44362883.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c44362883.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c44362883.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c44362883.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c44362883.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.branded_fusion_check or c44362883.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function c44362883.fcheck(tp,sg,fc)
	return sg:GetCount()<=2 and sg:IsExists(Card.IsFusionCode,1,nil,68468459)
end
function c44362883.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c44362883.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c44362883.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c44362883.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c44362883.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c44362883.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c44362883.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c44362883.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c44362883.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=tc.branded_fusion_check or c44362883.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
