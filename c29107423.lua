--紅蓮薔薇の魔女
---@param c Card
function c29107423.initial_effect(c)
	aux.AddCodeList(c,73580471)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29107423,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29107423)
	e1:SetCost(c29107423.thcost)
	e1:SetTarget(c29107423.thtg)
	e1:SetOperation(c29107423.thop)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29107423,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,29107424)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c29107423.tetg)
	e2:SetOperation(c29107423.teop)
	c:RegisterEffect(e2)
end
function c29107423.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c29107423.thfilter(c,tp,solve)
	return c:IsCode(17720747) and c:IsAbleToHand() and (solve or Duel.IsExistingMatchingCard(c29107423.dtfilter,tp,LOCATION_DECK,0,1,c))
end
function c29107423.dtfilter(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_PLANT)
end
function c29107423.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29107423.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c29107423.sumfilter(c)
	return c:IsCode(17720747) and c:IsSummonable(true,nil)
end
function c29107423.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29107423.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29107423,2))
		local dg=Duel.SelectMatchingCard(tp,c29107423.dtfilter,tp,LOCATION_DECK,0,1,1,nil)
		local dc=dg:GetFirst()
		if dc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(dc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
			if Duel.IsExistingMatchingCard(c29107423.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29107423,3)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c29107423.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
				local sc=sg:GetFirst()
				if sc then
					Duel.Summon(tp,sc,true,nil)
				end
			end
		end
	end
end
function c29107423.tefilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(73580471,40139997) and c:IsAbleToExtra()
end
function c29107423.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29107423.tefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c29107423.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29107423.tefilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
