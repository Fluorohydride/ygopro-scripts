--魔界劇団の楽屋入り
function c59057953.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59057953+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59057953.condition)
	e1:SetTarget(c59057953.target)
	e1:SetOperation(c59057953.operation)
	c:RegisterEffect(e1)
end
function c59057953.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return tc1 and tc1:IsSetCard(0x10ec) and tc2 and tc2:IsSetCard(0x10ec)
end
function c59057953.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10ec) and not c:IsForbidden()
end
function c59057953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c59057953.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c59057953.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59057953.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59057953,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59057953,0))
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoExtraP(tg1,tp,REASON_EFFECT)
	end
end
