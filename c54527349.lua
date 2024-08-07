--叛逆の堕天使
function c54527349.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,54527349+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c54527349.cost)
	e1:SetTarget(c54527349.target)
	e1:SetOperation(c54527349.activate)
	c:RegisterEffect(e1)
end
c54527349.fusion_effect=true
function c54527349.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c54527349.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c54527349.costfilter(c,e,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	if mg1:IsContains(c) then mg1:RemoveCard(c) end
	local res=Duel.IsExistingMatchingCard(c54527349.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			if mg2:IsContains(c) then mg2:RemoveCard(c) end
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c54527349.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xef) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and res
end
function c54527349.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c54527349.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c54527349.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(100,g:GetFirst():GetAttack())
	Duel.SendtoGrave(g,REASON_COST)
end
function c54527349.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,rec=e:GetLabel()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c54527349.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c54527349.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		e:SetLabel(0,0)
		return label==100 or res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	local cat=e:GetCategory()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and label==100 and rec>0 then
		e:SetCategory(bit.bor(cat,CATEGORY_RECOVER))
	else
		e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_RECOVER)))
	end
end
function c54527349.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c54527349.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c54527349.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c54527349.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
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
		local label,rec=e:GetLabel()
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and label==100 and rec>0 and Duel.SelectYesNo(tp,aux.Stringid(54527349,0)) then
			Duel.BreakEffect()
			Duel.Recover(tp,rec,REASON_EFFECT)
		end
	end
end
