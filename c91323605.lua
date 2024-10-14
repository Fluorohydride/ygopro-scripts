--奇異界開
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.xfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.filter(c,tp)
	return c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
		and not Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_FZONE,0,1,nil,c:GetCode())
end
function s.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
	if mg then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,mg)
		local sg=mg:RandomSelect(1-tp,1)
		Duel.ConfirmCards(tp,sg)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
