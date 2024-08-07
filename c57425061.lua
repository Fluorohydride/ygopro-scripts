--幻影融合
function c57425061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,57425061+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c57425061.target)
	e1:SetOperation(c57425061.activate)
	c:RegisterEffect(e1)
end
c57425061.fusion_effect=true
function c57425061.cfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
		and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c57425061.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c57425061.exfilter0(c)
	return c57425061.cfilter(c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c57425061.exfilter1(c,e)
	return c57425061.cfilter(c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c57425061.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c57425061.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)<=2
end
function c57425061.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)<=2
end
function c57425061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if Duel.IsExistingMatchingCard(c57425061.cfilter,tp,LOCATION_SZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c57425061.exfilter0,tp,LOCATION_SZONE,0,nil)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
				aux.FCheckAdditional=c57425061.fcheck
				aux.GCheckAdditional=c57425061.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c57425061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c57425061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c57425061.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c57425061.filter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c57425061.cfilter,tp,LOCATION_SZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c57425061.exfilter1,tp,LOCATION_SZONE,0,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c57425061.fcheck
		aux.GCheckAdditional=c57425061.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c57425061.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c57425061.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c57425061.fcheck
				aux.GCheckAdditional=c57425061.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_SZONE)
			mat1:Sub(rg)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
