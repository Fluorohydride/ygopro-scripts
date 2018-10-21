--Danger! Response Team
function c25140659.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25140659,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,25140659)
	e1:SetTarget(c25140659.target)
	e1:SetOperation(c25140659.activate)
	c:RegisterEffect(e1)
	--to deck and draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25140659,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,25140660)
	e2:SetCost(c25140659.tdcost)
	e2:SetTarget(c25140659.tdtg)
	e2:SetOperation(c25140659.tdop)
	c:RegisterEffect(e2)
end
function c25140659.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x11e) and c:IsAbleToHand()
		and Duel.IsExistingTarget(c25140659.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c25140659.filter2(c)
	return c:IsAbleToHand()
end
function c25140659.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c25140659.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c25140659.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c25140659.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c25140659.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c25140659.costfilter(c)
	return c:IsSetCard(0x11e) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c25140659.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25140659.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c25140659.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c25140659.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c25140659.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
