--サイバーダーク・インパクト！
---@param c Card
function c80033124.initial_effect(c)
	aux.AddCodeList(c,41230939,77625948,3019642)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80033124.target)
	e1:SetOperation(c80033124.activate)
	c:RegisterEffect(e1)
end
c80033124.fusion_effect=true
c80033124.fchecks=aux.CreateChecks(Card.IsFusionCode,{41230939,77625948,3019642})
function c80033124.ffilter0(c)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c80033124.ffilter(c,e)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and not c:IsImmuneToEffect(e)
end
function c80033124.spfilter(c,e,tp,sg)
	return c:IsCode(40418351) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and (not sg or Duel.GetLocationCountFromEx(tp,tp,sg,c)>0)
end
function c80033124.fgoal(g,e,tp)
	return Duel.IsExistingMatchingCard(c80033124.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c80033124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
		if not Duel.IsExistingMatchingCard(c80033124.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) then return false end
		local mg=Duel.GetMatchingGroup(c80033124.ffilter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		return mg:CheckSubGroupEach(c80033124.fchecks,c80033124.fgoal,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80033124.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function c80033124.cfilter2(c)
	return c:IsLocation(LOCATION_GRAVE) or (c:IsOnField() and c:IsFaceup())
end
function c80033124.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c80033124.ffilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroupEach(tp,c80033124.fchecks,false,c80033124.fgoal,e,tp)
	if not sg then return end
	local cg=sg:Filter(c80033124.cfilter,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
	local cg2=sg:Filter(c80033124.cfilter2,nil)
	if cg2:GetCount()>0 then
		Duel.HintSelection(cg2)
	end
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80033124.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	g:GetFirst():CompleteProcedure()
end
