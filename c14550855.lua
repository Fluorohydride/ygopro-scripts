--インフェルニティ・インフェルノ
function c14550855.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14550855.target)
	e1:SetOperation(c14550855.activate)
	c:RegisterEffect(e1)
end
function c14550855.filter(c)
	return c:IsSetCard(0xb) and c:IsAbleToGrave()
end
function c14550855.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ac=Duel.GetMatchingGroupCount(c14550855.filter,tp,LOCATION_DECK,0,nil)
		if ac==0 then return false end
		if ac>2 then ac=2 end
		local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_EFFECT,1,ac)
		return max>0 and Duel.CheckDiscardHand(tp,nil,1,REASON_DISCARD+REASON_EFFECT,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c14550855.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetMatchingGroupCount(c14550855.filter,tp,LOCATION_DECK,0,nil)
	if ac==0 then return end
	if ac>2 then ac=2 end
	local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_EFFECT,1,ac)
	if max<=0 then return end
	if min<=0 then min=1 end
	if Duel.DiscardHand(tp,nil,min,max,REASON_DISCARD+REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():GetCount()
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14550855.filter,tp,LOCATION_DECK,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
