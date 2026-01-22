--ドローパン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,200) end
	Duel.PayLPCost(tp,200)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-p,tc)
		if not tc:IsType(TYPE_MONSTER) then
			Duel.ShuffleHand(p)
			return
		end
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsAttribute,p,LOCATION_GRAVE,0,1,nil,tc:GetAttribute()) then
			local sg=Duel.GetMatchingGroup(Card.IsDiscardable,p,LOCATION_HAND,0,nil,REASON_EFFECT+REASON_DISCARD)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local dg=sg:Select(p,1,1,nil)
			Duel.ShuffleHand(p)
			Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
		else
			Duel.Draw(p,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(p)
	end
end
