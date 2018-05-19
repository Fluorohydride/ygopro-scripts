--オスティナート
function c9113513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9113513.condition)
	e1:SetTarget(c9113513.target)
	e1:SetOperation(c9113513.activate)
	c:RegisterEffect(e1)
end
function c9113513.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9113513.filter1(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
		and mg:IsExists(c9113513.filter2,1,c,e,tp,c,f,chkf)
end
function c9113513.filter2(c,e,tp,mc,f,chkf)
	local mg=Group.FromCards(c,mc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c9113513.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,f,chkf)
end
function c9113513.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9113513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		local res=mg1:IsExists(c9113513.filter1,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=mg2:IsExists(c9113513.filter1,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9113513.filter0(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c9113513.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c9113513.filter0,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e)
	local g1=mg1:Filter(c9113513.filter1,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local g2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		g2=mg2:Filter(c9113513.filter1,nil,e,tp,mg2,mf,chkf)
	end
	local tc=nil
	if g2~=nil and g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,ce:GetDescription())) then
		local mf=ce:GetValue()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg2:FilterSelect(tp,c9113513.filter1,1,1,nil,e,tp,mg2,mf,chkf)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg2:FilterSelect(tp,c9113513.filter2,1,1,nil,e,tp,sg1:GetFirst(),mf,chkf)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9113513.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,mf,chkf)
		tc=sg:GetFirst()
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,sg1)
	elseif g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg1:FilterSelect(tp,c9113513.filter1,1,1,nil,e,tp,mg1,nil,chkf)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg1:FilterSelect(tp,c9113513.filter2,1,1,nil,e,tp,sg1:GetFirst(),nil,chkf)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9113513.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,nil,chkf)
		tc=sg:GetFirst()
		tc:SetMaterial(sg1)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
	if tc then
		tc:RegisterFlagEffect(9113513,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9113513.descon)
		e1:SetOperation(c9113513.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9113513.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9113513)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9113513.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c)
end
function c9113513.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local mg=tc:GetMaterial()
	local sumtype=tc:GetSummonType()
	if Duel.Destroy(tc,REASON_EFFECT)~=0
		and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and mg:GetCount()>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=mg:GetCount()
		and mg:IsExists(aux.NecroValleyFilter(c9113513.mgfilter),mg:GetCount(),nil,e,tp,tc,mg)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.SelectYesNo(tp,aux.Stringid(9113513,0)) then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
