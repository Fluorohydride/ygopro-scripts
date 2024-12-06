--Heavy Polymerization
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.fusion_effect=true
function s.fcheck1(ct)
	return function(tp,sg,fc)
				if ct>0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>ct then
					return false
				end
				return true
			end
				
end
function s.fcheck2(tp,sg,fc)
	return sg:GetCount()>=3
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		if ct>0 then
			local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_EXTRA,0,nil)
			if mg2:GetCount()>0 then
				mg:Merge(mg2)
			end
		end
		aux.FCheckAdditional=s.fcheck1(ct)
		aux.FGoalCheckAdditional=s.fcheck2
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		aux.FCheckAdditional=nil
		aux.FGoalCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct>0 then
		local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_EXTRA,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
		end
	end
	aux.FCheckAdditional=s.fcheck1(ct)
	aux.FGoalCheckAdditional=s.fcheck2
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
		aux.FCheckAdditional=s.fcheck1(ct)
		aux.FGoalCheckAdditional=s.fcheck2
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.FGoalCheckAdditional=nil
		tc:SetMaterial(mat1)
		local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat1:Sub(rg)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	elseif ce then
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	local exmat=tc:GetMaterial():Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	if #exmat>0 then
		local dam=exmat:GetSum(Card.GetAttack)
		local lp=Duel.GetLP(tp)
		if lp>=dam then
			Duel.SetLP(tp,lp-dam)
		else
			Duel.SetLP(tp,0)
		end
	end
	Duel.SpecialSummonComplete()
	tc:CompleteProcedure()
	aux.FCheckAdditional=nil
	aux.FGoalCheckAdditional=nil
end
