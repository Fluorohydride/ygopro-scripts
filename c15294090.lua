--デステニー・ミラージュ
function c15294090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c15294090.condition)
	e1:SetTarget(c15294090.target)
	e1:SetOperation(c15294090.operation)
	c:RegisterEffect(e1)
end
function c15294090.cfilter(c,tp)
	return c:IsPreviousSetCard(0xc008) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c15294090.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and rp~=tp and eg:IsExists(c15294090.cfilter,1,nil,tp)
end
function c15294090.spfilter(c,e,tp)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==Duel.GetTurnCount() and c:IsSetCard(0xc008)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15294090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c15294090.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c15294090.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15294090.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or ft<g:GetCount() or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
