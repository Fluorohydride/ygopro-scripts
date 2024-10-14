--覇王天龍の魂
---@param c Card
function c76840111.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,76840111+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76840111.cost)
	e1:SetTarget(c76840111.target)
	e1:SetOperation(c76840111.activate)
	c:RegisterEffect(e1)
end
c76840111.fusion_effect=true
function c76840111.rfilter(c,tp)
	return c:GetBaseAttack()==2500 and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM)
end
function c76840111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c76840111.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c76840111.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c76840111.filter0(c)
	return c:IsAbleToRemove()
end
function c76840111.filter1(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c76840111.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCode(13331639) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c76840111.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c76840111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c76840111.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c76840111.filter3,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c76840111.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c76840111.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c76840111.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c76840111.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c76840111.filter3,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c76840111.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c76840111.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		local b1=Duel.IsExistingMatchingCard(c76840111.efilter1,tp,LOCATION_REMOVED,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c76840111.efilter2,tp,LOCATION_REMOVED,0,1,nil)
		local b3=Duel.IsExistingMatchingCard(c76840111.efilter3,tp,LOCATION_REMOVED,0,1,nil)
		local b4=Duel.IsExistingMatchingCard(c76840111.efilter4,tp,LOCATION_REMOVED,0,1,nil)
		if not b1 or not b2 or not b3 or not b4 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		tc:CompleteProcedure()
	end
end
function c76840111.efilter1(c)
	return c:IsSetCard(0x10f2) and c:IsFaceup()
end
function c76840111.efilter2(c)
	return c:IsSetCard(0x2073) and c:IsFaceup()
end
function c76840111.efilter3(c)
	return c:IsSetCard(0x2017) and c:IsFaceup()
end
function c76840111.efilter4(c)
	return c:IsSetCard(0x1046) and c:IsFaceup()
end
