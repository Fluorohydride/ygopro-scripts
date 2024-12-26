--メルフィーのかくれんぼ
---@param c Card
function c63644830.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c63644830.indtg)
	e2:SetValue(c63644830.indct)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63644830,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,63644830)
	e3:SetTarget(c63644830.drtg)
	e3:SetOperation(c63644830.drop)
	c:RegisterEffect(e3)
end
function c63644830.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function c63644830.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c63644830.tdfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAbleToDeck()
end
function c63644830.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c63644830.tdfilter,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c63644830.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
