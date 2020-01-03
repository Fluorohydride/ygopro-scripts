--王者の調和
function c27503418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c27503418.condition)
	e1:SetTarget(c27503418.target)
	e1:SetOperation(c27503418.activate)
	c:RegisterEffect(e1)
end
function c27503418.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsType(TYPE_SYNCHRO)
end
function c27503418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c27503418.filter1(c,e,tp,tc)
	local rlv=c:GetLevel()-tc:GetLevel()
	return rlv>0 and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
		and Duel.IsExistingMatchingCard(c27503418.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,rlv)
end
function c27503418.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	return rlv==0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c27503418.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c27503418.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc)
		and tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(27503418,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c27503418.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		local lv=g1:GetFirst():GetLevel()-tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c27503418.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		g2:AddCard(tc)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
	end
end
