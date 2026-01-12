--光波分光
function c98905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c98905.target)
	e1:SetOperation(c98905.activate)
	c:RegisterEffect(e1)
end
function c98905.filter(c,e,tp)
	return c:GetPreviousOverlayCountOnField()~=0 and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
		and c:IsReason(REASON_DESTROY) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98905.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c98905.spfilter(c,e,tp,cd)
	return c:IsType(TYPE_XYZ) and c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98905.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c98905.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c98905.filter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,c98905.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98905.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98905.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end
