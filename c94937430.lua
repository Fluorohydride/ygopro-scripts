--臨時収入
function c94937430.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c94937430.accon)
	e2:SetOperation(c94937430.acop)
	c:RegisterEffect(e2)
	aux.RegisterEachTimeEvent(c,EVENT_TO_DECK,c94937430.cfilter)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c94937430.accon2)
	e0:SetOperation(c94937430.acop2)
	c:RegisterEffect(e0)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c94937430.drcon)
	e3:SetCost(c94937430.drcost)
	e3:SetTarget(c94937430.drtg)
	e3:SetOperation(c94937430.drop)
	c:RegisterEffect(e3)
end
function c94937430.cfilter(c,e,tp)
	return c:IsLocation(LOCATION_EXTRA) and c:IsControler(tp)
end
function c94937430.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c94937430.cfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c94937430.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x1,1)
end
function c94937430.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(94937430)>0
end
function c94937430.acop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(94937430)
	e:GetHandler():ResetFlagEffect(94937430)
	e:GetHandler():AddCounter(0x1,ct,true)
end
function c94937430.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1)==3
end
function c94937430.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c94937430.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c94937430.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
