--Reject Reborn
function c78161960.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c78161960.condition)
	e1:SetOperation(c78161960.activate)
	c:RegisterEffect(e1)
end
function c78161960.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c78161960.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c78161960.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c78161960.filter2(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78161960.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	Duel.BreakEffect()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c78161960.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	and Duel.SelectYesNo(tp,aux.Stringid(78161960,0)) then
		local g=Duel.SelectTarget(tp,c78161960.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local g2=Duel.SelectTarget(tp,c78161960.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		g:Merge(g2)
		if g:GetCount()~=2 then return false end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end