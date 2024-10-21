--U.A.ターンオーバー・タクティクス
function c61613388.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,61613388+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c61613388.condition)
	e1:SetTarget(c61613388.target)
	e1:SetOperation(c61613388.activate)
	c:RegisterEffect(e1)
end
function c61613388.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb2)
end
function c61613388.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c61613388.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function c61613388.filter(c,e,tp)
	return c:IsSetCard(0xb2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c61613388.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c61613388.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c61613388.locfilter(c,sp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(sp)
end
function c61613388.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local ct1=Duel.GetOperatedGroup():FilterCount(c61613388.locfilter,nil,tp)
	local ct2=Duel.GetOperatedGroup():FilterCount(c61613388.locfilter,nil,1-tp)
	if ct1>Duel.GetLocationCount(tp,LOCATION_MZONE) then ct1=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if ct2>Duel.GetLocationCount(1-tp,LOCATION_MZONE) then ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE) end
	if ct1<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct1=1 end
	local g=Duel.GetMatchingGroup(c61613388.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct1)
	local sc=sg:GetFirst()
	while sc do
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
		end
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	if ct2>0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_DECK,1,nil,e,0,1-tp,false,false)
		and Duel.SelectYesNo(1-tp,aux.Stringid(61613388,1)) then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct2=1 end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_DECK,1,ct2,nil,e,0,1-tp,false,false)
		if sg2:GetCount()>0 then
			Duel.SpecialSummon(sg2,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
