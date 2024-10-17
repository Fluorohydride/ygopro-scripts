--ナチュル・ナーブ
---@param c Card
function c16940215.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16940215,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c16940215.discon)
	e1:SetCost(c16940215.discost)
	e1:SetTarget(c16940215.distg)
	e1:SetOperation(c16940215.disop)
	c:RegisterEffect(e1)
end
function c16940215.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c16940215.cfilter(c)
	return c:IsSetCard(0x2a) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c16940215.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,29942771)
	local b1=fe and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
	local b2=c:IsReleasable() and Duel.CheckReleaseGroup(tp,c16940215.cfilter,1,c)
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectYesNo(tp,fe:GetDescription())) then
		Duel.Hint(HINT_CARD,0,29942771)
		fe:UseCountLimit(tp)
		Duel.DiscardDeck(tp,2,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,c16940215.cfilter,1,1,c)
		g:AddCard(c)
		Duel.Release(g,REASON_COST)
	end
end
function c16940215.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16940215.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
