--幽合－ゴースト・フュージョン
---@param c Card
function c35705817.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,35705817+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c35705817.target)
	e1:SetOperation(c35705817.activate)
	c:RegisterEffect(e1)
end
function c35705817.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsRace(RACE_ZOMBIE)
end
function c35705817.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsOnField() and c:IsRace(RACE_ZOMBIE)
end
function c35705817.filter(c)
	return c:IsOnField() and c:IsRace(RACE_ZOMBIE)
end
function c35705817.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c35705817.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)<=1
end
function c35705817.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)<=1
end
function c35705817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c35705817.filter,nil)
		local mg2=Group.CreateGroup()
		if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
			mg2=Duel.GetMatchingGroup(c35705817.filter0,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
		end
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=c35705817.fcheck
			aux.GCheckAdditional=c35705817.gcheck
		end
		local res=Duel.IsExistingMatchingCard(c35705817.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c35705817.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35705817.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c35705817.filter1,nil,e)
	local exmat=false
	local mg2=Group.CreateGroup()
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		mg2=Duel.GetMatchingGroup(c35705817.filter0,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	end
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
		aux.FCheckAdditional=c35705817.fcheck
		aux.GCheckAdditional=c35705817.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c35705817.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c35705817.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
				aux.FCheckAdditional=c35705817.fcheck
				aux.GCheckAdditional=c35705817.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
			mat1:Sub(rg)
			Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
