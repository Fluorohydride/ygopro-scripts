--魔鍵－マフテア
function c99426088.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99426088.target)
	e1:SetOperation(c99426088.activate)
	c:RegisterEffect(e1)
end
function c99426088.exconfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c99426088.excon(tp)
	return Duel.IsExistingMatchingCard(c99426088.exconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99426088.ffilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c99426088.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x165) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99426088.fexfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c99426088.rfilter(c,e,tp)
	return c:IsSetCard(0x165)
end
function c99426088.rexfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c99426088.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c99426088.gcheck(sg,ec)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c99426088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local fmg1=Duel.GetFusionMaterial(tp):Filter(c99426088.ffilter1,nil,e)
		if c99426088.excon(tp) then
			local fmg2=Duel.GetMatchingGroup(c99426088.fexfilter,tp,LOCATION_DECK,0,nil)
			if fmg2:GetCount()>0 then
				fmg1:Merge(fmg2)
				aux.FCheckAdditional=c99426088.frcheck
				aux.GCheckAdditional=c99426088.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c99426088.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,fmg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local fmg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99426088.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,fmg3,mf,chkf)
			end
		end
		if not res then
			local rmg1=Duel.GetRitualMaterial(tp)
			local rmg2
			if c99426088.excon(tp) then
				rmg2=Duel.GetMatchingGroup(c99426088.rexfilter,tp,LOCATION_DECK,0,nil)
			end
			aux.RCheckAdditional=c99426088.frcheck
			aux.RGCheckAdditional=c99426088.gcheck
			res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c99426088.rfilter,e,tp,rmg1,rmg2,Card.GetLevel,"Greater")
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c99426088.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local fmg1=Duel.GetFusionMaterial(tp):Filter(c99426088.ffilter1,nil,e)
	local exmat=false
	if c99426088.excon(tp) then
		local fmg2=Duel.GetMatchingGroup(c99426088.fexfilter,tp,LOCATION_DECK,0,nil)
		if fmg2:GetCount()>0 then
			fmg1:Merge(fmg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c99426088.frcheck
		aux.GCheckAdditional=c99426088.gcheck
	end
	local fsg1=Duel.GetMatchingGroup(c99426088.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,fmg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local fmg3=nil
	local fsg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		fmg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		fsg2=Duel.GetMatchingGroup(c99426088.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,fmg3,mf,chkf)
	end
	local rmg1=Duel.GetRitualMaterial(tp)
	local rmg2
	if c99426088.excon(tp) then
		rmg2=Duel.GetMatchingGroup(c99426088.rexfilter,tp,LOCATION_DECK,0,nil)
	end
	aux.RCheckAdditional=c99426088.frcheck
	aux.RGCheckAdditional=c99426088.gcheck
	local rsg=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c99426088.rfilter,e,tp,rmg1,rmg2,Card.GetLevel,"Greater")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local off=1
	local ops={}
	local opval={}
	if fsg1:GetCount()>0 or (fsg2~=nil and fsg2:GetCount()>0) then
		ops[off]=aux.Stringid(99426088,0)
		opval[off-1]=1
		off=off+1
	end
	if rsg:GetCount()>0 then
		ops[off]=aux.Stringid(99426088,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=fsg1:Clone()
		if fsg2 then sg:Merge(fsg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		fmg1:RemoveCard(tc)
		if fsg1:IsContains(tc) and (fsg2==nil or not fsg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c99426088.frcheck
				aux.GCheckAdditional=c99426088.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,fmg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,fmg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	else
		::rcancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=rsg:Select(tp,1,1,nil):GetFirst()
		aux.RCheckAdditional=c99426088.frcheck
		aux.RGCheckAdditional=c99426088.gcheck
		local rmg=rmg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if rmg2 then rmg:Merge(rmg2) end
		if tc.mat_filter then
			rmg=rmg:Filter(tc.mat_filter,tc,tp)
		else
			rmg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=rmg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto rcancel
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
	end
end
