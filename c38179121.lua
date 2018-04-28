--究極進化薬
function c38179121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,38179121+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c38179121.cost)
	e1:SetTarget(c38179121.target)
	e1:SetOperation(c38179121.activate)
	c:RegisterEffect(e1)
end
function c38179121.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c38179121.spcost_selector(c,tp,g,sg,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c38179121.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=sg:FilterCount(Card.IsRace,nil,RACE_DINOSAUR)==1
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c38179121.filter(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c38179121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c38179121.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local exc=nil
	if g:GetCount()==1 and g:GetFirst():IsLocation(LOCATION_HAND) then exc=g:GetFirst() end
	local rg=Duel.GetMatchingGroup(c38179121.spcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,exc)
	local sg=Group.CreateGroup()
	if chk==0 then return rg:IsExists(c38179121.spcost_selector,1,nil,tp,rg,sg,1) end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=rg:FilterSelect(tp,c38179121.spcost_selector,1,1,nil,tp,rg,sg,i)
		sg:Merge(g1)
		rg:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c38179121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c38179121.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c38179121.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c38179121.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
