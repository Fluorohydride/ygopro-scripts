--オルターガイスト・フィジアラート
function c85673903.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85673903,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,85673903)
	e1:SetCondition(c85673903.spcon)
	e1:SetTarget(c85673903.sptg)
	e1:SetOperation(c85673903.spop)
	c:RegisterEffect(e1)
end
function c85673903.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x103) and c:IsControler(tp) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c85673903.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c85673903.cfilter,1,nil,tp)
end
function c85673903.tgfilter(c,e,tp)
	if not c:IsType(TYPE_LINK) then return false end
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c85673903.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c85673903.tgfilter(chkc,e,tp) and chkc~=eg:GetFirst() end
	if chk==0 then return Duel.IsExistingTarget(c85673903.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,eg:GetFirst(),e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c85673903.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eg:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c85673903.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	if c:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85673903,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0x103)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
