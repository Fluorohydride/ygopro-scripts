--バーニング・ソウル
function c10723472.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,10723472+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10723472.condition)
	e1:SetTarget(c10723472.target)
	e1:SetOperation(c10723472.activate)
	c:RegisterEffect(e1)
end
function c10723472.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsType(TYPE_SYNCHRO)
end
function c10723472.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10723472.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10723472.thfilter(c)
	return not c:IsCode(10723472) and c:IsAbleToHand()
end
function c10723472.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10723472.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10723472.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10723472.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=sg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,pg:GetFirst(),nil)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c10723472.tglimit)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10723472.tglimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
