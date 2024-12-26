--ファイバーポッド
---@param c Card
function c78706415.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c78706415.target)
	e1:SetOperation(c78706415.operation)
	c:RegisterEffect(e1)
end
function c78706415.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,0x1e,0x1e,nil,STATUS_BATTLE_DESTROYED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0x1e)
end
function c78706415.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,0x1e,0x1e,nil,STATUS_BATTLE_DESTROYED)
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end
