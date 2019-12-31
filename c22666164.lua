--督戦官コヴィントン
function c22666164.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22666164,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22666164.cost)
	e1:SetTarget(c22666164.target)
	e1:SetOperation(c22666164.operation)
	c:RegisterEffect(e1)
end
c22666164.spchecks=aux.CreateChecks(Card.IsCode,{60999392,23782705,96384007})
function c22666164.spcostfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsCode(60999392,23782705,96384007)
end
function c22666164.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22666164.spcostfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroupEach(c22666164.spchecks,aux.mzctcheck,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroupEach(tp,c22666164.spchecks,false,aux.mzctcheck,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c22666164.filter(c,e,tp)
	return c:IsCode(58054262) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c22666164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c22666164.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22666164.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22666164.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
