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
function c2390019.ffilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c2390019.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c,e,tp)
end
function c2390019.cfilter(c,fc,e,tp)
	if c:IsSetCard(0xf) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() then
		if e and tp then
			return Duel.IsExistingMatchingCard(c2390019.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,c,fc,e,tp)
		else return true end
	else return false end
end
function c2390019.filter(c,fc,e,tp)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2390019.cfilter2(c,g,mg,ft,rm)
	if not rm and ft==0 and not c:IsLocation(LOCATION_MZONE) then return false end
	local g2=g:Clone()
	g2:AddCard(c)
	local mg2=mg:Clone()
	mg2:Sub(g2)
	return mg2:GetClassCount(Card.GetCode)>=g2:GetCount()
end
function c2390019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2390019.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c2390019.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	e:SetLabelObject(rc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2390019.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,rc,e,tp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2390019.cfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local g=Group.CreateGroup()
	local rm=(ft>0)
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sc=rg:FilterSelect(tp,c2390019.cfilter2,1,1,nil,g,mg,ft,rm):GetFirst()
		g:AddCard(sc)
		rg:RemoveCard(sc)
		mg:RemoveCard(sc)
		if not sc:IsLocation(LOCATION_MZONE) then ft=ft-1 end
	until g:GetCount()==5 or rg:GetCount()==0 or mg:GetClassCount(Card.GetCode)==g:GetCount()
		or (ft==0 and not rg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE))
		or not Duel.SelectYesNo(tp,aux.Stringid(2390019,0))
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(Duel.GetOperatedGroup():GetCount())
end
function c2390019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c2390019.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=e:GetLabel()
	if ft<ct then return end
	local rc=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2390019.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,rc,e,tp)
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
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
