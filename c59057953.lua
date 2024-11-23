--魔界劇団の楽屋入り
---@param c Card
function c59057953.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59057953+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59057953.condition)
	e1:SetTarget(c59057953.target)
	e1:SetOperation(c59057953.operation)
	c:RegisterEffect(e1)
end
function c59057953.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x10ec)
end
function c59057953.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10ec)
end
function c59057953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c59057953.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_DECK)
end
function c59057953.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59057953.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59057953,0))
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoExtraP(tg1,nil,REASON_EFFECT)
end
