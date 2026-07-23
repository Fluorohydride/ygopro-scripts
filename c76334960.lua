--召喚魔術－「杯」
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.fmfilter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function s.fmfilter2(c,e)
	return c:IsLocation(LOCATION_MZONE) and not c:IsImmuneToEffect(e)
		and c:IsAbleToRemove()
end
function s.dmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.cmfilter(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
		and not c:IsImmuneToEffect(e)
end
function s.fspfilter1(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and c:IsSetCard(0xf4) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=s.fcheck1
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function s.fspfilter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and c:IsSetCard(0xf4) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=s.fcheck2
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function s.fcheck1(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)==1
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1
end
function s.fcheck2(tp,sg,fc)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
		and sg:FilterCount(Card.IsControler,nil,1-tp)==1
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.fmfilter1,nil,e)
	local mg2=Duel.GetMatchingGroup(s.dmfilter,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local mg3=Duel.GetFusionMaterial(tp):Filter(s.fmfilter2,nil,e)
	local mg4=Duel.GetMatchingGroup(s.cmfilter,tp,0,LOCATION_MZONE,nil,e)
	mg3:Merge(mg4)
	local res1=Duel.IsExistingMatchingCard(s.fspfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res1 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg5=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res1=Duel.IsExistingMatchingCard(s.fspfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg5,mf,chkf)
		end
	end
	local res2=Duel.IsExistingMatchingCard(s.fspfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,nil,chkf)
	if not res2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg6=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res2=Duel.IsExistingMatchingCard(s.fspfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg6,mf,chkf)
		end
	end
	if chk==0 then return res1 or res2 end
	local op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(id,1),1},
			{res2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Group.CreateGroup()
	local sg1=Group.CreateGroup()
	if e:GetLabel()==1 then
		mg1=Duel.GetFusionMaterial(tp):Filter(s.fmfilter1,nil,e)
		local mg2=Duel.GetMatchingGroup(s.dmfilter,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		sg1=Duel.GetMatchingGroup(s.fspfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	elseif e:GetLabel()==2 then
		mg1=Duel.GetFusionMaterial(tp):Filter(s.fmfilter2,nil,e)
		local mg2=Duel.GetMatchingGroup(s.cmfilter,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		sg1=Duel.GetMatchingGroup(s.fspfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	end
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		if e:GetLabel()==1 then
			sg2=Duel.GetMatchingGroup(s.fspfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		elseif e:GetLabel()==2 then
			sg2=Duel.GetMatchingGroup(s.fspfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if e:GetLabel()==1 then
				aux.FCheckAdditional=s.fcheck1
			elseif e:GetLabel()==2 then
				aux.FCheckAdditional=s.fcheck2
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
