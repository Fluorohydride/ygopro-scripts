--翼の恩返し
function c8843569.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8843569+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c8843569.drcon)
	e1:SetCost(c8843569.drcost)
	e1:SetTarget(c8843569.drtg)
	e1:SetOperation(c8843569.drop)
	c:RegisterEffect(e1)
end
function c8843569.cfilter(c,g)
	return c:IsFacedown() or not c:IsRace(RACE_WINDBEAST)
end
function c8843569.drcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>=2 and not g:IsExists(c8843569.cfilter,1,nil,g) and g:GetClassCount(Card.GetOriginalCodeRule)>=2
end
function c8843569.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c8843569.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c8843569.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
