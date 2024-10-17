--繋がれし魔鍵
---@param c Card
function c51510279.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c51510279.target)
	e1:SetOperation(c51510279.activate)
	c:RegisterEffect(e1)
end
c51510279.fusion_effect=true
function c51510279.thfilter(c)
	return (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c51510279.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c51510279.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51510279.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c51510279.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c51510279.ffilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c51510279.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x165) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP_DEFENSE) and c:CheckFusionMaterial(m,nil,chkf)
end
function c51510279.rfilter(c,e,tp)
	return c:IsSetCard(0x165) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP_DEFENSE)
end
function c51510279.activate(e,tp,eg,ep,ev,re,r,rp)
	local th=Duel.GetFirstTarget()
	if not th:IsRelateToEffect(e) or Duel.SendtoHand(th,nil,REASON_EFFECT)==0 or not th:IsLocation(LOCATION_HAND) then return end
	local chkf=tp
	local fmg1=Duel.GetFusionMaterial(tp):Filter(c51510279.ffilter1,nil,e)
	local fsg1=Duel.GetMatchingGroup(c51510279.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,fmg1,nil,chkf)
	local fmg2=nil
	local fsg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		fmg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		fsg2=Duel.GetMatchingGroup(c51510279.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,fmg2,mf,chkf)
	end
	local rmg1=Duel.GetRitualMaterial(tp)
	local rsg=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c51510279.rfilter,e,tp,rmg1,nil,Card.GetLevel,"Greater")
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(51510279,0)
	opval[off-1]=0
	off=off+1
	if fsg1:GetCount()>0 or (fsg2~=nil and fsg2:GetCount()>0) then
		ops[off]=aux.Stringid(51510279,1)
		opval[off-1]=1
		off=off+1
	end
	if rsg:GetCount()>0 then
		ops[off]=aux.Stringid(51510279,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		local sg=fsg1:Clone()
		if fsg2 then sg:Merge(fsg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		fmg1:RemoveCard(tc)
		if fsg1:IsContains(tc) and (fsg2==nil or not fsg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,fmg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,fmg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	elseif opval[op]==2 then
		::rcancel::
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=rsg:Select(tp,1,1,nil):GetFirst()
		local rmg=rmg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			rmg=rmg:Filter(tc.mat_filter,tc,tp)
		else
			rmg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=rmg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto rcancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_DEFENSE)
		tc:CompleteProcedure()
	end
end
