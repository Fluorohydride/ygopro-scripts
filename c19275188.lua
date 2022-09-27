--ウォークライ・ジェネレート
function c19275188.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19275188+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(c19275188.condition)
	e1:SetTarget(c19275188.target)
	e1:SetOperation(c19275188.operation)
	c:RegisterEffect(e1)
end
function c19275188.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c19275188.filter(c,e,tp)
	return c:IsSetCard(0x15f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19275188.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19275188.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19275188.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19275188.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetTurnPlayer()==1-tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c19275188.atklimit)
		tc:RegisterEffect(e1)
	end
end
function c19275188.atklimit(e,c)
	return c~=e:GetHandler()
end
