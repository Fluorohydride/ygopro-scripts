--RUM－ファントム・フォース
function c88504133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88504133,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88504133)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c88504133.condition)
	e1:SetCost(c88504133.cost)
	e1:SetTarget(c88504133.target)
	e1:SetOperation(c88504133.activate)
	c:RegisterEffect(e1)
end
function c88504133.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c88504133.cgfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c88504133.cefilter(c,tc,ct,e,tp)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0xba,0x10db,0x2073)
		and tc:IsCanBeXyzMaterial(c) and r>0 and ct>=r
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c88504133.cfilter(c,e,tp)
	local ct=Duel.GetMatchingGroupCount(c88504133.cgfilter,tp,LOCATION_GRAVE,0,nil)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
		and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c88504133.cefilter,tp,LOCATION_EXTRA,0,1,nil,c,ct,e,tp)
end
function c88504133.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c88504133.tgefilter(c,tc,e,tp,rank)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0xba,0x10db,0x2073)
		and tc:IsCanBeXyzMaterial(c) and r==rank
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c88504133.tgfilter(c,e,tp,rank)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c88504133.tgefilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp,rank)
end
function c88504133.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88504133.cfilter(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c88504133.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	local avail={}
	local availbool={}
	local ct=Duel.GetMatchingGroupCount(c88504133.cgfilter,tp,LOCATION_GRAVE,0,nil)
	local gfield=Duel.GetMatchingGroup(c88504133.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	for tc in aux.Next(gfield) do
		local gextra=Duel.GetMatchingGroup(c88504133.cefilter,tp,LOCATION_EXTRA,0,nil,tc,ct,e,tp)
		for ex in aux.Next(gextra) do
			local r=ex:GetRank()-tc:GetRank()
			if not availbool[r] then
				availbool[r]=true
				table.insert(avail,r)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88504133,1))
	local num=Duel.AnnounceNumber(tp,table.unpack(avail))
	e:SetLabel(num)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c88504133.cgfilter,tp,LOCATION_GRAVE,0,num,num,nil)
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c88504133.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,num)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88504133.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and tc:IsFaceup()
		and tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88504133.tgefilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp,e:GetLabel())
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c88504133.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c88504133.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
