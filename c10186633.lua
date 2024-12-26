--ENシャッフル
---@param c Card
function c10186633.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10186633)
	e1:SetTarget(c10186633.sptg)
	e1:SetOperation(c10186633.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10186634)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10186633.drtg)
	e2:SetOperation(c10186633.drop)
	c:RegisterEffect(e2)
end
function c10186633.tdfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3008,0x1f) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c10186633.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c10186633.spfilter(c,e,tp,code)
	return c:IsSetCard(0x3008,0x1f) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10186633.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10186633.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10186633.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c10186633.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local code=tc:GetCode()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10186633.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10186633.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsSetCard(0x3008,0x1f) or c:IsCode(89943723))
end
function c10186633.gcheck(g)
	return #g==1 and g:GetFirst():IsCode(89943723) or aux.gfcheck(g,Card.IsSetCard,0x3008,0x1f)
end
function c10186633.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanDraw(tp,1) then return false end
		local g=Duel.GetMatchingGroup(c10186633.filter,tp,LOCATION_GRAVE,0,nil)
		return g:CheckSubGroup(c10186633.gcheck,1,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10186633.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10186633.filter),tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c10186633.gcheck,false,1,2)
	if sg then
		Duel.HintSelection(sg)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			if not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
