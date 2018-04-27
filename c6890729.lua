--ボンディング-DHO
function c6890729.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c6890729.cost)
	e1:SetTarget(c6890729.target)
	e1:SetOperation(c6890729.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c6890729.thcost)
	e2:SetTarget(c6890729.thtg)
	e2:SetOperation(c6890729.thop)
	c:RegisterEffect(e2)
end
function c6890729.spcostfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsCode(43017476,22587018,58071123)
end
c6890729.spcost_list={43017476,22587018,58071123}
function c6890729.spcost_selector(c,tp,g,sg,i)
	if not c:IsCode(c6890729.spcost_list[i]) then return false end
	if i<3 then
		sg:AddCard(c)
		g:RemoveCard(c)
		local flag=g:IsExists(c6890729.spcost_selector,1,nil,tp,g,sg,i+1)
		sg:RemoveCard(c)
		g:AddCard(c)
		return flag
	else
		return true
	end
end
function c6890729.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c6890729.spcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:IsExists(c6890729.spcost_selector,1,nil,tp,g,sg,1)
	end
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=g:FilterSelect(tp,c6890729.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c6890729.filter(c,e,tp)
	return c:IsCode(6022371) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c6890729.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6890729.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c6890729.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c6890729.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c6890729.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c6890729.thfilter(c)
	return c:IsCode(6022371,85066822) and c:IsAbleToHand()
end
function c6890729.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6890729.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c6890729.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c6890729.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
