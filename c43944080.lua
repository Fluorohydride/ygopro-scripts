--ネムレリアの夢守り－クエット
---@param c Card
function c43944080.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43944080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c43944080.sprcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43944080,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,43944081)
	e2:SetCondition(c43944080.discon)
	e2:SetCost(c43944080.discost)
	e2:SetTarget(c43944080.distg)
	e2:SetOperation(c43944080.disop)
	c:RegisterEffect(e2)
end
function c43944080.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_EXTRA,0,1,nil,TYPE_PENDULUM)
end
function c43944080.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x191) and c:IsControler(tp) and c:IsFaceup()
end
function c43944080.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,1,nil,70155677) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c43944080.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c43944080.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c43944080.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c43944080.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c43944080.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c43944080.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
