--雪花の光
function c24940422.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24940422,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24940422)
	e1:SetCondition(c24940422.condition)
	e1:SetTarget(c24940422.target)
	e1:SetOperation(c24940422.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24940422,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,24940423)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c24940422.tdtg)
	e2:SetOperation(c24940422.tdop)
	c:RegisterEffect(e2)
end
function c24940422.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c24940422.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c24940422.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c24940422.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c24940422.aclimit(e,re,tp)
	return not re:GetHandler():IsCode(24940422) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function c24940422.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c24940422.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c24940422.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c24940422.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c24940422.tdfilter,p,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
