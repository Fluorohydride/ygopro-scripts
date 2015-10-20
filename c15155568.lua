--破壊剣一閃
function c15155568.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15155568.condition)
	e1:SetTarget(c15155568.target)
	e1:SetOperation(c15155568.activate)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c15155568.ngcon)
	e4:SetCost(c15155568.ngcost)
	e4:SetTarget(c15155568.ngtg)
	e4:SetOperation(c15155568.ngop)
	c:RegisterEffect(e4)
end
function c15155568.cfilter(c)
	return c:IsFaceup() and (c:IsCode(98502113) or c:IsCode(86240887))
end
function c15155568.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15155568.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c15155568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c15155568.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c15155568.ngcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if tg:GetCount()~=1 or not tc:IsLocation(LOCATION_MZONE) or not tc:IsSetCard(0xd7) or tc:IsControler(1-tp) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function c15155568.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c15155568.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c15155568.ngop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
