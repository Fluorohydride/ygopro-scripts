--魂のしもべ
function c23020408.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--set top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23020408,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c23020408.target)
	e1:SetOperation(c23020408.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23020408,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,23020408)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c23020408.drtg)
	e2:SetOperation(c23020408.drop)
	c:RegisterEffect(e2)
end
function c23020408.filter(c)
	return (aux.IsCodeOrListed(c,46986414) or aux.IsCodeOrListed(c,38033121)) and not c:IsCode(23020408)
		and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK))
end
function c23020408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23020408.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c23020408.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23020408,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c23020408.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.HintSelection(g)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c23020408.cfilter(c)
	return (c:IsCode(46986414,38033121) or (c:IsSetCard(0x139) and c:IsType(TYPE_MONSTER))) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c23020408.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c23020408.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c23020408.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c23020408.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Draw(p,ct,REASON_EFFECT)
end
