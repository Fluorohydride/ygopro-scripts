--アルバスの落胤
function c68468459.initial_effect(c)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,68468459)
	e1:SetCondition(c68468459.condition)
	e1:SetCost(c68468459.cost)
	e1:SetTarget(c68468459.target)
	e1:SetOperation(c68468459.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c68468459.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function c68468459.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c68468459.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c68468459.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c68468459.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c68468459.chkfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c68468459.fcheck(c)
	return function(tp,sg,fc)
				return not sg:IsExists(c68468459.chkfilter,1,c,tp)
			end
end
function c68468459.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(c68468459.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(c68468459.filter0,tp,0,LOCATION_MZONE,nil):Filter(c68468459.filter1,nil,e)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
		end
		aux.FGoalCheckAdditional=c68468459.fcheck(c)
		local res=Duel.IsExistingMatchingCard(c68468459.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c68468459.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,c,chkf)
			end
		end
		aux.FGoalCheckAdditional=nil
		return res and c:IsRelateToEffect(e)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c68468459.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)~=0 then return end
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(c68468459.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c68468459.filter0,tp,0,LOCATION_MZONE,nil):Filter(c68468459.filter1,nil,e)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
	end
	aux.FGoalCheckAdditional=c68468459.fcheck(c)
	local sg1=Duel.GetMatchingGroup(c68468459.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c68468459.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FGoalCheckAdditional=nil
end
