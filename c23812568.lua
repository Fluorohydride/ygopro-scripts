--アディショナル・ミラー・レベル7
---@param c Card
function c23812568.initial_effect(c)
	aux.EnableExtraDeckSummonCountLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c23812568.condition)
	e1:SetCost(c23812568.cost)
	e1:SetTarget(c23812568.target)
	e1:SetOperation(c23812568.activate)
	c:RegisterEffect(e1)
end
function c23812568.filter1(c,tp)
	return c:IsFaceup() and c:IsLevel(7) and c:IsControler(tp)
end
function c23812568.filter2(c,e,tp)
	return c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c23812568.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp,c:GetCode())
end
function c23812568.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23812568.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23812568.filter1,1,nil,tp)
end
function c23812568.cfilter(c,tp)
	return c:IsCode(23812568) and c:IsAbleToGraveAsCost()
end
function c23812568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23812568.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23812568.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c23812568.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c23812568.filter1,nil,tp):Filter(c23812568.filter2,nil,e,tp)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and #mg>0 end
	local g=mg
	if #mg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=mg:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c23812568.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c23812568.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c23812568.checkop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(92345028)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c23812568.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,nil,e,tp,tc:GetCode())
	if #g~=2 then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local atk=Duel.GetOperatedGroup():GetSum(Card.GetBaseAttack)
		if atk==0 then return end
		Duel.BreakEffect()
		Duel.Damage(tp,atk,REASON_EFFECT)
	end
end
function c23812568.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and aux.ExtraDeckSummonCountLimit[sump]<=0
end
function c23812568.ckfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c23812568.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c23812568.ckfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(c23812568.ckfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end
