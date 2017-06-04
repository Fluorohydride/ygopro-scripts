--二重光波
function c63992027.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c63992027.condition)
	e1:SetTarget(c63992027.target)
	e1:SetOperation(c63992027.operation)
	c:RegisterEffect(e1)
end
function c63992027.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c63992027.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:IsSetCard(0x107b) or c:IsSetCard(0xe5)) and c:GetOverlayCount()>0
		and (not e or Duel.IsExistingMatchingCard(c63992027.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c))
end
function c63992027.spfilter(c,e,tp,ec)
	return c:IsCode(ec:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c63992027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c63992027.filter(chkc,nil,nil) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c63992027.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c63992027.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c63992027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local og=tc:GetOverlayGroup()
	if og:GetCount()==0 then return end
	if Duel.SendtoGrave(og,REASON_EFFECT)~=0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c63992027.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
