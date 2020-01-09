--エーリアン・ソルジャー M／フレーム
function c74974229.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_REPTILE),2,2)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74974229,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,74974229)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c74974229.ctcost)
	e1:SetTarget(c74974229.cttg)
	e1:SetOperation(c74974229.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74974229,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,74974230)
	e2:SetCondition(c74974229.spcon)
	e2:SetTarget(c74974229.sptg)
	e2:SetOperation(c74974229.spop)
	c:RegisterEffect(e2)
end
function c74974229.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsDiscardable()
end
function c74974229.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74974229.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c74974229.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c74974229.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x100e,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x100e)
end
function c74974229.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x100e,1)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x100e,1)
	end
end
function c74974229.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c74974229.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74974229.ctfilter(c)
	return c:GetCounter(0x100e)>0
end
function c74974229.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74974229.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c74974229.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c74974229.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c74974229.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetMatchingGroupCount(c74974229.ctfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
