--捕食植物サンデウ・キンジー
function c89181134.initial_effect(c)
	--fusattribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_FUSION_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c89181134.attrtg)
	e1:SetValue(c89181134.attrval)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89181134,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,89181134)
	e2:SetTarget(c89181134.target)
	e2:SetOperation(c89181134.operation)
	c:RegisterEffect(e2)
end
function c89181134.attrtg(e,c)
	return c:GetCounter(0x1041)>0
end
function c89181134.attrval(e,c,rp)
	if rp==e:GetHandlerPlayer() then
		return ATTRIBUTE_DARK
	else return c:GetAttribute() end
end
function c89181134.filter0(c,tp)
	return c:IsCanBeFusionMaterial() and (c:IsControler(tp) or (c:IsFaceup() and c:GetCounter(0x1041)>0))
end
function c89181134.filter1(c,e,tp)
	return c89181134.filter0(c,tp) and not c:IsImmuneToEffect(e)
end
function c89181134.filter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c89181134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c89181134.filter0,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,c,tp)
		local res=Duel.IsExistingMatchingCard(c89181134.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c89181134.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c89181134.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c89181134.filter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,c,e,tp)
	local sg1=Duel.GetMatchingGroup(c89181134.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c89181134.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
