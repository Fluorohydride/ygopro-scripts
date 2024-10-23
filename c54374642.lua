--Ai－SHOW
function c54374642.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c54374642.condition)
	e1:SetTarget(c54374642.target)
	e1:SetOperation(c54374642.operation)
	c:RegisterEffect(e1)
end
function c54374642.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x135) and c:IsLinkAbove(3) and c:GetSequence()>=5
end
function c54374642.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c54374642.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c54374642.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and not c:IsType(TYPE_LINK) and c:IsAttack(2300)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c54374642.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if chk==0 then return tc:IsControler(1-tp) and tc:IsAttackAbove(2300)
		and Duel.IsExistingMatchingCard(c54374642.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c54374642.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c54374642.exfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c54374642.fselect(g,ft1,ft2,ect,ft,atk)
	return #g<=ft and #g<=ect
		and g:FilterCount(c54374642.exfilter1,nil)<=ft1
		and g:FilterCount(c54374642.exfilter2,nil)<=ft2
		and g:GetSum(Card.GetAttack)<=atk
end
function c54374642.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or not tc:IsAttackAbove(2300) then return end
	local g=Duel.GetMatchingGroup(c54374642.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #g==0 then return end
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft>0 then ft=1 end
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	if ect==0 or ft1==0 and ft2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c54374642.fselect,false,1,ft,ft1,ft2,ect,ft,tc:GetAttack())
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
