--一か八か
function c74202664.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,74202664+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c74202664.condition)
	e1:SetTarget(c74202664.target)
	e1:SetOperation(c74202664.activate)
	c:RegisterEffect(e1)
end
function c74202664.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c74202664.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if chk==0 then return #g>0 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238)
		or g:IsExists(Card.IsAbleToHand,1,nil)) end
end
function c74202664.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc:IsType(TYPE_MONSTER) and (tc:IsLevel(1) or tc:IsLevel(8)) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if not tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0) then return end
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local b1=Duel.GetLP(tp)~=1000
		local ea=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DAMAGE)
		local eb=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_RECOVER)
		local b2=Duel.GetLP(1-tp)<8000 and (ea or not eb)
		local b3=true
		local off=0
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(74202664,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(74202664,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(74202664,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(1-tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.SetLP(tp,1000)
		elseif opval[op]==2 then
			Duel.Recover(1-tp,8000-Duel.GetLP(1-tp),REASON_EFFECT)
		else return end
	end
end
