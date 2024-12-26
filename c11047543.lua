--サイコ・フィール・ゾーン
---@param c Card
function c11047543.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11047543,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11047543.target)
	e1:SetOperation(c11047543.operation)
	c:RegisterEffect(e1)
end
function c11047543.filter1(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c11047543.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c11047543.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsRace(RACE_PSYCHO) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c11047543.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c11047543.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c11047543.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c11047543.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c11047543.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c11047543.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11047543.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()~=2 or Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local sg=Duel.GetMatchingGroup(c11047543.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
