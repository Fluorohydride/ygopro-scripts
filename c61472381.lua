--巧炎星－エランセイ
---@param c Card
function c61472381.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61472381,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,61472381)
	e1:SetCost(c61472381.setcost)
	e1:SetTarget(c61472381.settg)
	e1:SetOperation(c61472381.setop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61472381,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,61472382)
	e2:SetCondition(c61472381.discon)
	e2:SetCost(c61472381.discost)
	e2:SetTarget(c61472381.distg)
	e2:SetOperation(c61472381.disop)
	c:RegisterEffect(e2)
end
function c61472381.costfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c61472381.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61472381.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c61472381.costfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function c61472381.setfilter(c)
	return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c61472381.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61472381.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c61472381.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61472381.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c61472381.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c61472381.costfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x79,0x7c) and not c:IsCode(61472381) and c:IsAbleToGraveAsCost()
end
function c61472381.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61472381.costfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsPlayerAffectedByEffect(tp,46241344) end
	if Duel.IsExistingMatchingCard(c61472381.costfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c61472381.costfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c61472381.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c61472381.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
