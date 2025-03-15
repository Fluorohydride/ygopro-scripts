--サイバーロード・フュージョン
function c55704856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,55704856+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c55704856.target)
	e1:SetOperation(c55704856.activate)
	c:RegisterEffect(e1)
end
function c55704856.filter1(c,e)
	return (c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c55704856.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x1093) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FGoalCheckAdditional=c.cyber_fusion_check or c55704856.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FGoalCheckAdditional=nil
	return res
end
function c55704856.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c55704856.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x1093)
end
function c55704856.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c55704856.filter1,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
		local mg2=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsLocation),nil,LOCATION_HAND)
		mg:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c55704856.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c55704856.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c55704856.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c55704856.filter1,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,e)
	local mg2=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsLocation),nil,LOCATION_HAND)
	mg:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c55704856.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c55704856.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FGoalCheckAdditional=tc.cyber_fusion_check or c55704856.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat:Filter(c55704856.cfilter,nil):GetCount()>0 then
				local cg=mat:Filter(c55704856.cfilter,nil)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(55704856,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c55704856.ftarget)
		e1:SetLabel(fid)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	aux.FGoalCheckAdditional=nil
end
function c55704856.cfilter(c)
	return c:IsLocation(LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end
function c55704856.ftarget(e,c)
	return e:GetLabel()~=c:GetFlagEffectLabel(55704856)
end
