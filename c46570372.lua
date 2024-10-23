--鎮魂の決闘
function c46570372.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,46570372+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c46570372.target)
	e1:SetOperation(c46570372.activate)
	c:RegisterEffect(e1)
end
function c46570372.filter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsReason(REASON_BATTLE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c46570372.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c46570372.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c46570372.filter,tp,0,LOCATION_GRAVE,1,nil,e,1-tp,Duel.GetTurnCount())) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c46570372.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c46570372.filter),tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(46570372,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			if tc:IsCode(89943723) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetRange(LOCATION_MZONE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCondition(c46570372.atkcon)
				e1:SetValue(c46570372.atkval)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c46570372.filter),1-tp,LOCATION_GRAVE,0,nil,e,1-tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(46570372,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
	Duel.SpecialSummonComplete()
end
function c46570372.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local a,d=Duel.GetBattleMonster(0)
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (a==e:GetHandler() and d or a and d==e:GetHandler()) then
		e:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
		return true
	end
	return false
end
function c46570372.atkval(e,c)
	return e:GetHandler():GetAttack()*2
end
