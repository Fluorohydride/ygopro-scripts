--影依の偽典
function c21011044.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--fusion summon
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x9d),
		mat_location=LOCATION_MZONE+LOCATION_GRAVE,
		mat_filter=Card.IsAbleToRemove,
		mat_operation=aux.FMaterialRemove,
		category=CATEGORY_TOGRAVE,
		opinfo=c21011044.opinfo,
		foperation=c21011044.fop,
		reg=false
	})
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,21011044)
	e1:SetCondition(c21011044.condition)
	c:RegisterEffect(e1)
end
function c21011044.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c21011044.opinfo(e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_MZONE)
end
function c21011044.fop(e,tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local attr=tc:GetAttribute()
	if tc:IsFaceup() and Duel.IsExistingMatchingCard(c21011044.tgfilter,tp,0,LOCATION_MZONE,1,nil,attr)
		and Duel.SelectYesNo(tp,aux.Stringid(21011044,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c21011044.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,attr)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c21011044.tgfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr) and c:IsAbleToGrave()
end
