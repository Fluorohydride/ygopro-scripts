--王魂調和
function c24590232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c24590232.condition)
	e1:SetOperation(c24590232.activate)
	c:RegisterEffect(e1)
end
function c24590232.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c24590232.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and lv<9 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c24590232.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end
function c24590232.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end
function c24590232.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c24590232.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.GetLocationCountFromEx(tp)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c24590232.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(24590232,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c24590232.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c24590232.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
	end
end
