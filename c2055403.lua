--時空の落とし穴
function c2055403.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c2055403.target)
	e1:SetOperation(c2055403.activate)
	c:RegisterEffect(e1)
end
function c2055403.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_HAND+LOCATION_EXTRA)
		and c:IsAbleToDeck() and c:IsLocation(LOCATION_MZONE)
end
function c2055403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c2055403.filter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end

function c2055403.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c2055403.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
		end
	end
end
