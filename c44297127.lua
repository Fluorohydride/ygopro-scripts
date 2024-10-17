--奇跡の穿孔
---@param c Card
function c44297127.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,44297127+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c44297127.target)
	e1:SetOperation(c44297127.activate)
	c:RegisterEffect(e1)
end
function c44297127.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c44297127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local draw=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,59419719)
	if chk==0 then return Duel.IsExistingMatchingCard(c44297127.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and (not draw or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c44297127.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c44297127.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,59419719) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
