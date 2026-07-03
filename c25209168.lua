--絶望と希望の逆転
function c25209168.initial_effect(c)
	aux.AddCodeList(c,17484499)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25209168,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,25209168+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c25209168.condition)
	e1:SetTarget(c25209168.target)
	e1:SetOperation(c25209168.activate)
	c:RegisterEffect(e1)
end
function c25209168.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c25209168.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c25209168.cfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c25209168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c25209168.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local p=Duel.GetTurnPlayer()
	local g1=g:Filter(Card.IsControler,nil,p)
	local g2=g:Filter(Card.IsControler,nil,1-p)
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(p,LOCATION_MZONE)
	if ft1>1 and Duel.IsPlayerAffectedByEffect(p,59822133) then ft1=1 end
	local ct1=g:FilterCount(c25209168.ctfilter,nil,1-p)
	if ct1>ft1 then ct1=ft1 end
	local ft2=Duel.GetLocationCount(1-p,LOCATION_MZONE)
	if ft2>1 and Duel.IsPlayerAffectedByEffect(1-p,59822133) then ft2=1 end
	local ct2=g1:FilterCount(c25209168.ctfilter,nil,p)
	if ct2>ft2 then ct2=ft2 end
	local sg1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),p,0,LOCATION_GRAVE,nil,e,0,p,false,false)
	local sg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),1-p,0,LOCATION_GRAVE,nil,e,0,1-p,false,false)
	local tg1=Group.CreateGroup()
	local tg2=Group.CreateGroup()
	if ft1>0 and sg1:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(25209168,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		tg1=sg1:Select(p,1,ct1,nil)
		Duel.HintSelection(tg1)
	end
	if ft2>0 and sg2:GetCount()>0 and Duel.SelectYesNo(1-p,aux.Stringid(25209168,1)) then
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_SPSUMMON)
		tg2=sg2:Select(1-p,1,ct2,nil)
		Duel.HintSelection(tg2)
	end
	if tg1:GetCount()>0 or tg2:GetCount()>0 then
		Duel.BreakEffect()
		for sc1 in aux.Next(tg1) do
			Duel.SpecialSummonStep(sc1,0,p,p,false,false,POS_FACEUP)
		end
		for sc2 in aux.Next(tg2) do
			Duel.SpecialSummonStep(sc2,0,1-p,1-p,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		local stg=Duel.GetMatchingGroup(c25209168.stfilter,tp,LOCATION_DECK,0,nil)
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,17484499) and stg:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(25209168,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=stg:Select(tp,1,1,nil):GetFirst()
			if tc and Duel.SSet(tp,tc)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(25209168,3))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c25209168.ctfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p) and c:IsType(TYPE_MONSTER)
end
function c25209168.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
