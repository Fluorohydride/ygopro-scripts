--地殻変動
function c60866277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60866277.target)
	e1:SetOperation(c60866277.operation)
	c:RegisterEffect(e1)
end
function c60866277.desfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c60866277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then
		if g:GetCount()==0 then return false end
		local tc=g:GetFirst()
		local att=0
		while tc do
			att=bit.bor(att,tc:GetAttribute())
			tc=g:GetNext()
		end
		return bit.band(att,att-1)~=0
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60866277.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()==0 then return false end
	local tc=sg:GetFirst()
	local att=0
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=sg:GetNext()
	end
	if bit.band(att,att-1)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att1=Duel.AnnounceAttribute(tp,2,att)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATTRIBUTE)
	local att2=Duel.AnnounceAttribute(1-tp,1,att1)
	local g=Duel.GetMatchingGroup(c60866277.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,att2)
	Duel.Destroy(g,REASON_EFFECT)
end
