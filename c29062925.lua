--絵札融合
function c29062925.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29062925+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29062925.target)
	e1:SetOperation(c29062925.activate)
	c:RegisterEffect(e1)
end
function c29062925.exconfilter(c)
	return c:IsCode(25652259,64788463,90876561) and c:IsFaceup()
end
function c29062925.excon(tp)
	return Duel.IsExistingMatchingCard(c29062925.exconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c29062925.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c29062925.filter2(c,e,tp,m,f,chkf)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c29062925.fexfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c29062925.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c29062925.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c29062925.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c29062925.filter1,nil,e)
		if c29062925.excon(tp) then
			local mg2=Duel.GetMatchingGroup(c29062925.fexfilter,tp,LOCATION_DECK,0,nil)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=c29062925.frcheck
				aux.GCheckAdditional=c29062925.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c29062925.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c29062925.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29062925.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c29062925.filter1,nil,e)
	local exmat=false
	if c29062925.excon(tp) then
		local mg2=Duel.GetMatchingGroup(c29062925.fexfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c29062925.frcheck
		aux.GCheckAdditional=c29062925.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c29062925.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c29062925.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c29062925.frcheck
				aux.GCheckAdditional=c29062925.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
