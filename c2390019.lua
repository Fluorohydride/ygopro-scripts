--おジャマ改造
function c2390019.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2390019.cost)
	e1:SetTarget(c2390019.target)
	e1:SetOperation(c2390019.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c2390019.drtg)
	e2:SetOperation(c2390019.drop)
	c:RegisterEffect(e2)
end
function c2390019.cfilter(c)
	return c:IsSetCard(0xf) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c2390019.spfilter(c,e,tp,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2390019.fselect(cg,tp,tg)
	return Duel.GetMZoneCount(tp,cg,tp)>=#cg and tg:Filter(aux.TRUE,cg):CheckSubGroup(aux.dncheck,#cg,#cg)
end
function c2390019.ffilter(c,e,tp,cg)
	if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)) then return false end
	local tg=Duel.GetMatchingGroup(c2390019.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,c)
	local maxct=math.min(#tg,#cg,5)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then maxct=1 end
	return cg:CheckSubGroup(c2390019.fselect,1,maxct,tp,tg)
end
function c2390019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c2390019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c2390019.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c2390019.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,cg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,c2390019.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,cg):GetFirst()
	Duel.ConfirmCards(1-tp,fc)
	e:SetLabelObject(fc)
	local tg=Duel.GetMatchingGroup(c2390019.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,fc)
	local maxct=math.min(#tg,#cg,5)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then maxct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=cg:SelectSubGroup(tp,c2390019.fselect,false,1,maxct,tp,tg)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c2390019.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=e:GetLabel()
	if ft<ct then return end
	local fc=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2390019.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,fc)
	if mg:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c2390019.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and c:IsSetCard(0xf) and c:IsAbleToDeck()
end
function c2390019.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c2390019.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c2390019.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c2390019.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c2390019.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
