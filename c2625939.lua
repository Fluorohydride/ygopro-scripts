--スプール・コード
function c2625939.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c2625939.condition)
	e1:SetOperation(c2625939.activate)
	c:RegisterEffect(e1)
end
function c2625939.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,3,nil,RACE_CYBERSE)
end
function c2625939.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	if Duel.NegateAttack() and ft>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,2625940,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
		and Duel.SelectYesNo(tp,aux.Stringid(2625939,0)) then
		Duel.BreakEffect()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		repeat
			local token=Duel.CreateToken(tp,2625940)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			ft=ft-1
		until ft==0 or not Duel.SelectYesNo(tp,210)
		Duel.SpecialSummonComplete()
	end
end
