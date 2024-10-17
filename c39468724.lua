--アラドヴァルの影霊衣
---@param c Card
function c39468724.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--Burialing
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39468724,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,39468724)
	e2:SetCost(c39468724.tgcost)
	e2:SetTarget(c39468724.tgtg)
	e2:SetOperation(c39468724.tgop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(39468724,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,39468725)
	e3:SetCondition(c39468724.negcon)
	e3:SetCost(c39468724.negcost)
	e3:SetTarget(aux.nbtg)
	e3:SetOperation(c39468724.negop)
	c:RegisterEffect(e3)
end
function c39468724.mat_filter(c)
	return not c:IsLevel(10)
end
function c39468724.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c39468724.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb4)
end
function c39468724.tgfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToGrave()
end
function c39468724.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39468724.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.CheckReleaseGroupEx(tp,c39468724.filter,1,REASON_EFFECT,true,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c39468724.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c39468724.tgfilter,tp,LOCATION_DECK,0,nil)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,c39468724.filter,1,ct,REASON_EFFECT,true,nil)
	if g:GetCount()>0 then
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c39468724.tgfilter,tp,LOCATION_DECK,0,rct,rct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c39468724.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c39468724.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,REASON_COST,true,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c39468724.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
