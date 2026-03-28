--未来融合－フューチャー・フュージョン・ノヴァ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,70095154)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=s.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function s.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,70095154)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	local fid=0
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=s.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		aux.FCheckAdditional=nil
		tc:CompleteProcedure()
		c:SetCardTarget(tc)
		fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		if c:IsOnField() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsRelateToChain() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(s.desop)
			e1:SetReset(RESET_EVENT+RESET_TOFIELD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetCondition(s.descon2)
			e2:SetOperation(s.desop2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			c:SetCardTarget(tc)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(s.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_ATTACK)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetTarget(s.ftarget)
		e4:SetLabel(fid)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFlagEffectLabel(id)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
