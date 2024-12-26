--S－Force スペシメン
---@param c Card
function c82977464.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82977464,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,82977464)
	e1:SetCondition(c82977464.spcon)
	e1:SetTarget(c82977464.sptg)
	e1:SetOperation(c82977464.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82977464,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,82977464)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82977464.mvtg)
	e2:SetOperation(c82977464.mvop)
	c:RegisterEffect(e2)
end
function c82977464.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c82977464.spfilter(c,e,tp,zone)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c82977464.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	for lc in aux.Next(lg) do
		zone=bit.bor(zone,lc:GetColumnZone(LOCATION_MZONE,tp))
	end
	zone=zone&0x1f
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c82977464.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82977464.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82977464.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c82977464.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=0
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	for lc in aux.Next(lg) do
		zone=bit.bor(zone,lc:GetColumnZone(LOCATION_MZONE,tp))
	end
	zone=zone&0x1f
	if zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c82977464.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156)
end
function c82977464.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82977464.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82977464.mvfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82977464,2))
	Duel.SelectTarget(tp,c82977464.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82977464.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or not tc:IsControler(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
