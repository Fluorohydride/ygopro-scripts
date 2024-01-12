--アドバンスドロー
function c51630558.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c51630558.cost)
	e1:SetTarget(c51630558.target)
	e1:SetOperation(c51630558.activate)
	c:RegisterEffect(e1)
end
function c51630558.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(8)
end
function c51630558.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c51630558.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c51630558.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c51630558.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c51630558.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
