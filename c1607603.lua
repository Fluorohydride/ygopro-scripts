--想定GUYS
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.sdfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.slfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsRace(RACE_WARRIOR) and c:IsFaceup() and lv>0 and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp)
end
function s.lvfilter(c,lv,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==1 and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	local b1 = not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sdfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.slfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),0},
		{b2,aux.Stringid(id,1),1})
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.slfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local op = e:GetLabel()
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if op==0 then
		g = Duel.SelectMatchingCard(tp,s.sdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	else
		local tc = Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() or not tc:IsType(TYPE_MONSTER) then return end
		g = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.lvfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetLevel(),e,tp)
	end
	if g and g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
