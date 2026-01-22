--スプライト・ダブルクロス
function c68250822.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68250822,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,68250822+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c68250822.target1)
	e1:SetOperation(c68250822.operation1)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68250822,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,68250822+EFFECT_COUNT_CODE_OATH)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c68250822.target2)
	e2:SetOperation(c68250822.operation2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(68250822,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,68250822+EFFECT_COUNT_CODE_OATH)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c68250822.target3)
	e3:SetOperation(c68250822.operation3)
	c:RegisterEffect(e3)
end
function c68250822.filter1(c)
	return c:IsRank(2) and c:IsFaceup()
end
function c68250822.cfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c68250822.filter1,tp,LOCATION_MZONE,0,1,c)
end
function c68250822.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c68250822.cfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c68250822.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c68250822.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c68250822.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c68250822.filter1,tp,LOCATION_MZONE,0,1,1,tc)
	if #g==0 then return end
	local tc2=g:GetFirst()
	if not tc:IsImmuneToEffect(e) and not tc2:IsImmuneToEffect(e) and tc:IsCanOverlay() then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc2,Group.FromCards(tc))
	end
end
function c68250822.getzone(tp)
	local g=Duel.GetMatchingGroup(Card.IsLink,tp,LOCATION_MZONE,0,nil,2)
	local zone=0
	for lc in aux.Next(g) do
		zone=zone|lc:GetLinkedZone()
	end
	return zone&0x1f
end
function c68250822.filter2(c,zone)
	return c:IsControlerCanBeChanged(false,zone)
end
function c68250822.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c68250822.getzone(tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c68250822.filter2(chkc,zone) end
	if chk==0 then return Duel.IsExistingTarget(c68250822.filter2,tp,0,LOCATION_MZONE,1,nil,zone) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c68250822.filter2,tp,0,LOCATION_MZONE,1,1,nil,zone)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c68250822.operation2(e,tp,eg,ep,ev,re,r,rp)
	local zone=c68250822.getzone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.GetControl(tc,tp,0,0,zone)
	end
end
function c68250822.filter3(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c68250822.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c68250822.getzone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c68250822.filter3(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c68250822.filter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c68250822.filter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c68250822.operation3(e,tp,eg,ep,ev,re,r,rp)
	local zone=c68250822.getzone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
