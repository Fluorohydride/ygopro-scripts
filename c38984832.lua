--GMX 55th Experiment Report
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.digtg)
	e2:SetOperation(s.digop)
	c:RegisterEffect(e2)
end
function s.matdeckfilter(c)
	return c:IsSetCard(0x1dd) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.matfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.oppmonster(tp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function s.fusionfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DINOSAUR) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.matfilter1,nil,e)
		if s.oppmonster(tp) then
			local mg2=Duel.GetMatchingGroup(s.matdeckfilter,tp,LOCATION_DECK,0,nil)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=s.fcheck
				aux.GCheckAdditional=s.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.matfilter1,nil,e)
	local exmat=false
	if s.oppmonster(tp) then
		local mg2=Duel.GetMatchingGroup(s.matdeckfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=s.fcheck
		aux.GCheckAdditional=s.gcheck
	end
	local sg1=Duel.GetMatchingGroup(s.fusionfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.fusionfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not (ce and Duel.SelectYesNo(tp,ce:GetDescription()))) then
			if exmat then
				aux.FCheckAdditional=s.fcheck
				aux.GCheckAdditional=s.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce and mg3 then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			if fop then fop(ce,e,tp,tc,mat2) end
		end
		if tc then tc:CompleteProcedure() end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x1dd) and c:IsAbleToHand()
end
function s.deckgmx(c)
	return c:IsSetCard(0x1dd)
end
function s.confirm_decktop_s(tp,count)
	local max_decktop=5
	if count>max_decktop then
		local g=Duel.GetDecktopGroup(tp,count)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.ConfirmDecktop(tp,count)
	end
end
function s.digtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function s.digop(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	local mg=Duel.GetMatchingGroup(s.deckgmx,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()==0 then return end
	local seq=-1
	local qc=nil
	for sc in aux.Next(mg) do
		if sc:GetSequence()>seq then
			seq=sc:GetSequence()
			qc=sc
		end
	end
	if not qc then return end
	local nflip=dcount-seq
	s.confirm_decktop_s(tp,nflip)
	if e:GetHandler():IsSetCard(0x1dd) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1595137,e,0,tp,tp,0)
	end
	local g=Duel.GetDecktopGroup(tp,nflip)
	if g:GetCount()==0 then return end
	if qc:IsAbleToHand() then
		Duel.SendtoHand(qc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,Group.FromCards(qc))
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoGrave(qc,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
end
