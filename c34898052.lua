--牙竜咆哮
function c34898052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34898052,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c34898052.cost)
	e1:SetTarget(c34898052.target)
	e1:SetOperation(c34898052.activate)
	c:RegisterEffect(e1)
end
function c34898052.rfilter(c,att)
	return (not att or c:IsAttribute(att)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
c34898052.cost_table={ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND}
function c34898052.rcostselector(c,g,sg,i)
	if not c:IsAttribute(c34898052.cost_table[i]) then return false end
	if i<4 then
		g:RemoveCard(c)
		sg:AddCard(c)
		local flag=g:IsExists(c34898052.rcostselector,1,nil,g,sg,i+1)
		g:AddCard(c)
		sg:RemoveCard(c)
		return flag
	else
		return true
	end
end
function c34898052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c34898052.rfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	if chk==0 then return g:IsExists(c34898052.rcostselector,1,nil,g,sg,1) end
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c34898052.rcostselector,1,1,nil,g,sg,i)
		g:Sub(g1)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c34898052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c34898052.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
