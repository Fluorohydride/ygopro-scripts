--魔弾の射手 ザ・キッド
function c5230799.initial_effect(c)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--draw
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(aux.mskregcon)
	e0:SetOperation(aux.mskreg)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5230799,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,5230799)
	e3:SetCondition(c5230799.drcon)
	e3:SetCost(c5230799.drcost)
	e3:SetTarget(c5230799.drtg)
	e3:SetOperation(c5230799.drop)
	c:RegisterEffect(e3)
end
function c5230799.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(ev)>0
end
function c5230799.cfilter(c)
	return c:IsSetCard(0x108) and c:IsDiscardable()
end
function c5230799.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5230799.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c5230799.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c5230799.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c5230799.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
