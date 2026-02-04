--GMX Applied Experiment #55
local s,id,o=GetID()
function s.initial_effect(c)
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
function s.cfilter1(c,tp)
	return c:IsSetCard(0x1dd) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_DECK,0,1,c)
end
function s.cfilter2(c)
	return c:IsRace(RACE_DINOSAUR)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsPlayerCanDiscardDeck(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1dd) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_DECK,0,nil,tp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	local seq1=-1
	local spcard1=nil
	for tc in aux.Next(g1) do
		if tc:GetSequence()>seq1 then
			seq1=tc:GetSequence()
			spcard1=tc
		end
	end
	local g2=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_DECK,0,nil)
	local seq2=-1
	local spcard2=nil
	for tc in aux.Next(g2) do
		if tc:GetSequence()>seq2 and tc:GetSequence()~=seq1 then
			seq2=tc:GetSequence()
			spcard2=tc
		end
	end
	if seq1==-1 or seq2==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	if seq2<seq1 then seq1=seq2 end
	Duel.ConfirmDecktop(tp,dcount-seq1)
	Duel.SetLP(tp,Duel.GetLP(tp)-(dcount-seq1)*400)
	local mg=Duel.GetDecktopGroup(tp,dcount-seq1):Filter(Card.IsType,nil,TYPE_MONSTER)
	local chkf=tp
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.BreakEffect()
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce~=nil then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Duel.ShuffleDeck(tp)
end
