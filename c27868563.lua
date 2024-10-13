--百鬼羅刹 神速ブーン
function c27868563.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27868563,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c27868563.spcon)
	e1:SetTarget(c27868563.sptg)
	e1:SetOperation(c27868563.spop)
	c:RegisterEffect(e1)
end
function c27868563.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c27868563.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27868563.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27868563.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c27868563.splimit(e,c)
	return c:IsCode(27868563)
end