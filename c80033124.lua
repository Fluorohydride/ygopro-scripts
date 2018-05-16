--サイバーダーク・インパクト！
function c80033124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80033124.target)
	e1:SetOperation(c80033124.activate)
	c:RegisterEffect(e1)
end
function c80033124.ffilter0(c)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c80033124.ffilter(c,e)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and not c:IsImmuneToEffect(e)
end
function c80033124.spfilter(c,e,tp)
	return c:IsCode(40418351) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c80033124.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c80033124.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c80033124.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c80033124.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c80033124.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c80033124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
		if not Duel.IsExistingMatchingCard(c80033124.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
		local mg=Duel.GetMatchingGroup(c80033124.ffilter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		return mg:IsExists(c80033124.fselect,1,nil,tp,mg,sg,41230939,77625948,3019642)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80033124.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function c80033124.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if not Duel.IsExistingMatchingCard(c80033124.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c80033124.ffilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg=Group.CreateGroup()
	if not mg:IsExists(c80033124.fselect,1,nil,tp,mg,sg,41230939,77625948,3019642) then return end
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c80033124.fselect,1,1,sg,tp,mg,sg,41230939,77625948,3019642)
		sg:Merge(g)
	end
	local cg=sg:Filter(c80033124.cfilter,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80033124.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	g:GetFirst():CompleteProcedure()
end
