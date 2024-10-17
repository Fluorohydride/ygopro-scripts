--王の棺
---@param c Card
function c16528181.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c16528181.efilter)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c16528181.intg)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(4,16528181)
	e2:SetCost(c16528181.cost)
	e2:SetTarget(c16528181.target)
	e2:SetOperation(c16528181.activate)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16528181,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16528181.descon)
	e3:SetTarget(c16528181.destg)
	e3:SetOperation(c16528181.desop)
	c:RegisterEffect(e3)
end
function c16528181.intg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x19d)
end
function c16528181.efilter(e,re,rp,c)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function c16528181.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c16528181.filter(c)
	return c:IsSetCard(0x19d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c16528181.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16528181.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c16528181.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16528181.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c16528181.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsSetCard(0x19d)) then return false end
	local bc=ac:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function c16528181.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,bc,1,0,0)
end
function c16528181.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsControler(1-tp) and bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end
