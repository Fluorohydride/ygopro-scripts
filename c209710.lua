--フリック・クラウン
---@param c Card
function c209710.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(209710,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,209710)
	e1:SetCondition(c209710.drcon)
	e1:SetCost(c209710.drcost)
	e1:SetTarget(c209710.drtg)
	e1:SetOperation(c209710.drop)
	c:RegisterEffect(e1)
end
function c209710.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c209710.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c209710.cfilter,tp,LOCATION_MZONE,0,2,e:GetHandler())
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c209710.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c209710.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c209710.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
