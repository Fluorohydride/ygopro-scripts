--壱時砲固定式
function c70916046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,70916046+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c70916046.condition)
	e1:SetTarget(c70916046.target)
	e1:SetOperation(c70916046.activate)
	c:RegisterEffect(e1)
end
function c70916046.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c70916046.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsLevelAbove(1)
end
function c70916046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70916046.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	local t={}
	local i=1
	for i=1,6 do t[i]=i end
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,0,0,0)
end
function c70916046.activate(e,tp,eg,ep,ev,re,r,rp)
	--Set up the equation
	local dnum=e:GetLabel()
	local fnum=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local gnum=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local dg=Duel.SelectMatchingCard(tp,c70916046.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if #dg==0 then return end
	local mon=dg:GetFirst()
	local lnum=mon:GetLevel()
	--The equation
	if ((lnum*dnum)+fnum)==gnum then
		--Select number of cards to send from Deck to GY
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local t={}
		local i=1
		if dcount<=dnum then
			for i=1,dcount do t[i]=i end
		else
			for i=1,dnum do t[i]=i end
		end
		local snum=Duel.AnnounceNumber(tp,table.unpack(t))
		if Duel.DiscardDeck(tp,snum,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local tdnum=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
			if tdnum<=0 or #tdg<=0 then return end
			--Shuffle opponent's cards into Deck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=tdg:Select(tp,1,tdnum,nil)
			Duel.HintSelection(rg)
			Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	else
		--Lose LP
		Duel.SetLP(tp,Duel.GetLP(tp)-dnum*500)
	end
end
