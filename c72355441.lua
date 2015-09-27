--エクシーズ・ギフト
function c72355441.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c72355441.condition)
	e1:SetTarget(c72355441.target)
	e1:SetOperation(c72355441.activate)
	c:RegisterEffect(e1)
end
function c72355441.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c72355441.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72355441.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c72355441.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c72355441.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) then return end
	local count=2
	while count>0 do
		local sg=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,nil,tp,1,REASON_EFFECT)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,532)
			sg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local oc=sg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
			local mg=oc:GetOverlayGroup():Select(tp,1,count,nil)
			count=count-mg:GetCount()
			Duel.SendtoGrave(mg,REASON_EFFECT)
		else
			sg:GetFirst():RemoveOverlayCard(tp,count,count,REASON_EFFECT)
			count=0
		end
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end
