--海造賊－白髭の機関士
---@param c Card
function c31374201.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31374201,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,31374201)
	e1:SetCondition(c31374201.spcon1)
	e1:SetTarget(c31374201.sptg1)
	e1:SetOperation(c31374201.spop1)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31374201,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31374202)
	e2:SetCondition(c31374201.spcon2)
	e2:SetTarget(c31374201.sptg2)
	e2:SetOperation(c31374201.spop2)
	c:RegisterEffect(e2)
end
function c31374201.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c31374201.cfilter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(c31374201.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute())
end
function c31374201.spfilter1(c,e,tp,attr)
	return c:IsSetCard(0x13f) and c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c31374201.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c31374201.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c31374201.cfilter2(c)
	return c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
end
function c31374201.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c31374201.cfilter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	local attr=0
	while tc do
		attr=attr|tc:GetAttribute()
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c31374201.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,attr)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) then
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if not Duel.Equip(tp,c,sc,false) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(sc)
		e1:SetValue(c31374201.eqlimit)
		c:RegisterEffect(e1)
	end
end
function c31374201.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c31374201.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE)
end
function c31374201.spfilter2(c,e,tp)
	return c:IsSetCard(0x13f) and not c:IsCode(31374201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31374201.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c31374201.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c31374201.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c31374201.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31374201.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c31374201.splimit(e,c)
	return not c:IsSetCard(0x13f)
end
