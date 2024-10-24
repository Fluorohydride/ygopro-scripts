--アマゾネス転生術
---@param c Card
function c6459419.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c6459419.target)
	e1:SetOperation(c6459419.activate)
	c:RegisterEffect(e1)
end
function c6459419.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4)
end
function c6459419.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c6459419.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6459419.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c6459419.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c6459419.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6459419.dfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c6459419.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6459419,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=sg:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
