--イタチの大暴発
function c31044787.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c31044787.condition)
	e1:SetTarget(c31044787.target)
	e1:SetOperation(c31044787.activate)
	c:RegisterEffect(e1)
end
function c31044787.filter(c,tp)
	return c:IsFaceup() and c:GetAttack()>0 and Duel.IsPlayerCanSendtoDeck(tp,c)
end
function c31044787.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31044787.filter,tp,0,LOCATION_MZONE,nil,1-tp)
	local atk=g:GetSum(Card.GetAttack)
	return atk>Duel.GetLP(tp)
end
function c31044787.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_MZONE)
end
function c31044787.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31044787.filter,tp,0,LOCATION_MZONE,nil,1-tp)
	local atk=g:GetSum(Card.GetAttack)
	local lp=Duel.GetLP(tp)
	local diff=atk-lp
	if diff<=0 then return end
	local sg=g:SelectWithSumGreater(1-tp,Card.GetAttack,diff)
	Duel.SendtoDeck(sg,nil,2,REASON_RULE)
end
