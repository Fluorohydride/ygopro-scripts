--白の烙印
function c34995106.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34995106,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,34995106)
	e1:SetTarget(c34995106.target)
	e1:SetOperation(c34995106.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34995106.regcon)
	e2:SetOperation(c34995106.regop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34995106,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,34995107)
	e3:SetCondition(c34995106.setcon)
	e3:SetTarget(c34995106.settg)
	e3:SetOperation(c34995106.setop)
	c:RegisterEffect(e3)
end
function c34995106.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c34995106.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c34995106.spfilter(c,e,tp,m,f,chkf)
	return (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c34995106.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsCode(68468459)
end
function c34995106.exfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c34995106.fcheck(tp,sg,fc)
	if sg:IsExists(c34995106.chkfilter,1,nil,tp) then
		return sg:IsExists(Card.IsRace,1,nil,RACE_DRAGON)
	else
		return sg:IsExists(Card.IsRace,1,nil,RACE_DRAGON) and not sg:IsExists(c34995106.exfilter,1,nil,tp)
	end
end
function c34995106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c34995106.filter2,nil,e)
		local mg2=Duel.GetMatchingGroup(c34995106.filter1,tp,LOCATION_GRAVE,0,nil,e)
		if mg1:IsExists(c34995106.chkfilter,1,nil,tp) and mg2:GetCount()>0 or mg2:IsExists(c34995106.chkfilter,1,nil,tp) then
			mg1:Merge(mg2)
		end
		aux.FGoalCheckAdditional=c34995106.fcheck
		local res=Duel.IsExistingMatchingCard(c34995106.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c34995106.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		aux.FGoalCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c34995106.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c34995106.filter2,nil,e)
	local mg2=Duel.GetMatchingGroup(c34995106.filter1,tp,LOCATION_GRAVE,0,nil,e)
	if mg1:IsExists(c34995106.chkfilter,1,nil,tp) and mg2:GetCount()>0 or mg2:IsExists(c34995106.chkfilter,1,nil,tp) then
		mg1:Merge(mg2)
	end
	aux.FGoalCheckAdditional=c34995106.fcheck
	local sg1=Duel.GetMatchingGroup(c34995106.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c34995106.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Sub(mat2)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FGoalCheckAdditional=nil
end
function c34995106.regcon(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return e:GetHandler():IsReason(REASON_COST) and re and re:IsActivated() and (code1==68468459 or code2==68468459)
end
function c34995106.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(34995106,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c34995106.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(34995106)>0
end
function c34995106.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c34995106.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
