--シンクロコール
function c89974904.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c89974904.target)
	e1:SetOperation(c89974904.activate)
	c:RegisterEffect(e1)
end
function c89974904.spfilter(c,e,tp,mg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c89974904.synfilter,tp,LOCATION_EXTRA,0,1,nil,c,mg)
end
function c89974904.matfilter(c,sc,lv)
	return c:GetSynchroLevel(c,sc)<=lv
end
function c89974904.syngfilter(c,sc,sg,g,olv)
	local mg=g:Clone()
	mg:RemoveCard(c)
	local lv=olv-c:GetSynchroLevel(sc)
	if lv<0 then return false end
	local sg2=sg:Clone()
	sg2:AddCard(c)
	if lv==0 then 
		return sc:IsSynchroSummonable(nil,sg2)
	else
		local tc=mg:GetFirst()
		while tc do
			if c89974904.syngfilter(tc,sc,sg2,mg,lv) then return true end
			tc=mg:GetNext()
		end
		return false
	end
end
function c89974904.synfilter(c,pc,g)
	local mg=g:Clone()
	if not c:IsRace(RACE_DRAGON+RACE_FIEND) or not c:IsAttribute(ATTRIBUTE_DARK)
		or not c:IsType(TYPE_SYNCHRO) then return false end
	local lv=c:GetLevel()-pc:GetSynchroLevel(c)
	if lv<=0 then return false end
	mg=mg:Filter(c89974904.matfilter,nil,c,lv)
	local tc=mg:GetFirst()
	while tc do
		local mg2=mg:Clone()
		mg2:RemoveCard(tc)
		local sg=Group.FromCards(pc)
		if c89974904.syngfilter(tc,c,sg,mg2,lv) then return true end
		tc=mg:GetNext()
	end
	return false
end
function c89974904.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89974904.spfilter(chkc,e,tp,mg) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c89974904.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c89974904.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c89974904.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,nil)
		if mg:IsContains(tc) then mg:RemoveCard(tc) end
		local g=Duel.GetMatchingGroup(c89974904.synfilter,tp,LOCATION_EXTRA,0,nil,tc,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			local mat=Group.FromCards(tc)
			local lv=sc:GetLevel()-tc:GetSynchroLevel(sc)
			while lv>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local m2=mg:FilterSelect(tp,c89974904.syngfilter,1,1,nil,sc,mat,mg,lv)
				mat:AddCard(m2:GetFirst())
				mg:RemoveCard(m2:GetFirst())
				lv=lv-m2:GetFirst():GetSynchroLevel(sc)
			end
			sc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_MATERIAL+REASON_SYNCHRO)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
