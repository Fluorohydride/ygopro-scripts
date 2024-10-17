--身代わりの闇
---@param c Card
function c76045757.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c76045757.condition)
	e1:SetTarget(c76045757.target)
	e1:SetOperation(c76045757.operation)
	c:RegisterEffect(e1)
end
function c76045757.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (ep==1-tp and Duel.IsChainDisablable(ev)) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c76045757.tgfilter(c)
	return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c76045757.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76045757.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c76045757.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c76045757.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c76045757.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
