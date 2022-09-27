--WWの鈴音
function c96156729.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,96156729+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c96156729.cost)
	e1:SetTarget(c96156729.target)
	e1:SetOperation(c96156729.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(96156729,ACTIVITY_SPSUMMON,c96156729.counterfilter)
end
function c96156729.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c96156729.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(96156729,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c96156729.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c96156729.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c96156729.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf0) and Duel.IsExistingMatchingCard(c96156729.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c96156729.spfilter(c,e,tp,code)
	return c:IsSetCard(0xf0) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c96156729.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c96156729.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(c96156729.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c96156729.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c96156729.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c96156729.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		local sc=g:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
