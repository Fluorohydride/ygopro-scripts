--ナチュルの春風
function c34813545.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34813545.target)
	e1:SetOperation(c34813545.activate)
	c:RegisterEffect(e1)
end
function c34813545.spfilter(c,e,tp)
	return c:IsSetCard(0x2a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34813545.mfilter(c)
	return c:IsSetCard(0x2a) and c:IsType(TYPE_MONSTER)
end
function c34813545.syncheck(g,tp,syncard)
	return g:IsExists(c34813545.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c34813545.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c34813545.syncheck,2,#mg,tp,c)
end
function c34813545.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c34813545.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c34813545.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsSetCard,1,nil,0x2a)
end
function c34813545.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local synmg=Duel.GetSynchroMaterial(tp)
	if synmg:IsExists(Card.GetHandSynchro,1,nil) then
		local synmg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if synmg2:GetCount()>0 then synmg:Merge(synmg2) end
	end
	local chkf=tp
	local fusmg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	aux.FCheckAdditional=c34813545.fcheck
	local res=Duel.IsExistingMatchingCard(c34813545.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,fusmg1,nil,chkf)
	aux.FCheckAdditional=nil
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local fusmg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c34813545.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,fusmg2,mf,chkf)
		end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c34813545.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c34813545.scfilter,tp,LOCATION_EXTRA,0,1,nil,synmg)
	local b3=res
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(34813545,0)},
		{b2,aux.Stringid(34813545,1)},
		{b3,aux.Stringid(34813545,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c34813545.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c34813545.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		local g=Duel.GetMatchingGroup(c34813545.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=mg:SelectSubGroup(tp,c34813545.syncheck,false,2,#mg,tp,sc)
			Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
		end
	elseif op==3 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_ONFIELD):Filter(c34813545.filter1,nil,e)
		aux.FCheckAdditional=c34813545.fcheck
		local sg1=Duel.GetMatchingGroup(c34813545.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c34813545.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				aux.FCheckAdditional=c34813545.fcheck
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				aux.FCheckAdditional=nil
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
end
