--黒魔導のカーテン
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
	return c:IsPublic() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=false
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(1-tp) then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 or Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) then
			for lv=1,12 do
				if Duel.IsPlayerCanSpecialSummonMonster(1-tp,0,0,TYPE_MONSTER,-2,-2,lv,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP) then
					b2=true
					break
				end
			end
		end
		b2=b2 or Duel.IsExistingMatchingCard(s.spfilter2,1-tp,LOCATION_HAND,0,1,nil,e,1-tp)
	end
	if chk==0 then return b1 or b2 end
end
function s.thfilter(c)
	return not c:IsCode(id) and aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	local ss=false
	for p in aux.TurnPlayers() do
		if Duel.GetLocationCount(p,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,p,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,p)
			and Duel.SelectYesNo(p,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(p,s.spfilter,p,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,p):GetFirst()
			if Duel.SpecialSummonStep(sc,0,p,p,false,false,POS_FACEUP) then
				ss=true
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				if p==tp then
					res=sc:IsOriginalCodeRule(46986414,38033121)
				end
			end
		end
	end
	if ss then
		Duel.SpecialSummonComplete()
	end
	if res and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
