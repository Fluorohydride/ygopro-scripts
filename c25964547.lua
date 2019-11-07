--Dream Mirror Hypnagogia
function c25964547.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,25964547+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c25964547.target)
	e1:SetOperation(c25964547.activate)
	c:RegisterEffect(e1)
end
function c25964547.cfilter1(c,tp)
	return c:IsCode(74665651) and not c:IsForbidden() and ((c:CheckUniqueOnField(tp)
		and Duel.IsExistingMatchingCard(c25964547.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,1-tp))
		or (c:CheckUniqueOnField(1-tp)
		and Duel.IsExistingMatchingCard(c25964547.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,tp)))
end
function c25964547.cfilter2(c,p)
	return c:IsCode(1050355) and c:CheckUniqueOnField(p) and not c:IsForbidden()
end
function c25964547.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25964547.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c25964547.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c25964547.cfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local b1=g1:IsExists(Card.CheckUniqueOnField,1,nil,tp)
	local b2=g1:IsExists(Card.CheckUniqueOnField,1,nil,1-tp)
	if not b1 and not b2 then return end
	local g2=Duel.GetMatchingGroup(c25964547.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local g3=Duel.GetMatchingGroup(c25964547.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,1-tp)
	local tg1=nil
	local tg2=nil
	if b1 and not b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,0))
		tg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,1))
		tg2=g3:Select(tp,1,1,nil)
	end
	if not b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,0))
		tg1=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,1))
		tg2=g1:Select(tp,1,1,nil)
	end
	if b1 and b2 then
		local g=g1:Clone()
		g:Merge(g2)
		g:Merge(g3)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,0))
		tg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25964547,1))
		tg2=g:Select(tp,1,1,nil)
	end
	Duel.MoveToField(tg1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveToField(tg2:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end
