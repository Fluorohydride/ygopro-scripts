--Sin World
---@param c Card
function c27564031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27564031,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c27564031.condition)
	e2:SetTarget(c27564031.target)
	e2:SetOperation(c27564031.operation)
	c:RegisterEffect(e2)
end
function c27564031.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c27564031.filter(c)
	return c:IsSetCard(0x23) and c:IsAbleToHand()
end
function c27564031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(c27564031.filter,tp,LOCATION_DECK,0,3,nil) end
	aux.GiveUpNormalDraw(e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c27564031.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27564031.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
