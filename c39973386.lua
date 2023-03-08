--表裏一体
function c39973386.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,39973386)
	e1:SetTarget(c39973386.target)
	e1:SetOperation(c39973386.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,39973387)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c39973386.tdtg)
	e2:SetOperation(c39973386.tdop)
	c:RegisterEffect(e2)
end
function c39973386.costfilter(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup())
		and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:GetOriginalLevel()>0
		and Duel.IsExistingMatchingCard(c39973386.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function c39973386.spfilter(c,tc,e,tp)
	if c:GetOriginalAttribute()==tc:GetOriginalAttribute() then return end
	local b1=c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp,tc)>0
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and c:GetOriginalRace()==tc:GetOriginalRace()
		and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2)
end
function c39973386.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.CheckReleaseGroup(tp,c39973386.costfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c39973386.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c39973386.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c39973386.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c39973386.tdfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
function c39973386.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c39973386.tdfilter(chkc) end
	local g=Duel.GetMatchingGroup(c39973386.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(aux.dabcheck,2,2) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c39973386.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
