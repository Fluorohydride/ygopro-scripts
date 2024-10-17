--暗黒界の登極
---@param c Card
function c65956182.initial_effect(c)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65956182,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65956182)
	e1:SetCondition(c65956182.condition)
	e1:SetTarget(c65956182.target)
	e1:SetOperation(c65956182.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65956182,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65956183)
	e2:SetTarget(c65956182.thtg)
	e2:SetOperation(c65956182.thop)
	c:RegisterEffect(e2)
end
c65956182.fusion_effect=true
function c65956182.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
end
function c65956182.filter1(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_ONFIELD)
end
function c65956182.filter2(c,e,tp,mg1,dm,f,chkf)
	local mg=mg1:Clone()
	if c:IsSetCard(0x6) then
		mg:Merge(dm)
	end
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function c65956182.filter3(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c65956182.filter4(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsDiscardable() and not c:IsImmuneToEffect(e)
end
function c65956182.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c65956182.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(c65956182.filter3,tp,LOCATION_GRAVE,0,nil,e)
		local dg=Duel.GetMatchingGroup(c65956182.filter4,tp,LOCATION_HAND,0,nil,e)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c65956182.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,dg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c65956182.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,dg,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c65956182.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c65956182.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c65956182.filter3,tp,LOCATION_GRAVE,0,nil,e)
	local dg=Duel.GetMatchingGroup(c65956182.filter4,tp,LOCATION_HAND,0,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c65956182.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,dg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c65956182.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,dg,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x6) then mg1:Merge(dg) end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			for gc in aux.Next(mat1) do
				if gc:IsLocation(LOCATION_HAND) then
					Duel.SendtoGrave(gc,REASON_EFFECT+REASON_DISCARD+REASON_FUSION+REASON_MATERIAL)
				else
					Duel.Remove(gc,POS_FACEUP,REASON_EFFECT+REASON_FUSION+REASON_MATERIAL)
				end
			end
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
function c65956182.thfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6)
end
function c65956182.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c65956182.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c65956182.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,c65956182.thfilter,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
