--マジック・ドレイン
function c59344077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c59344077.condition)
	e1:SetOperation(c59344077.activate)
	c:RegisterEffect(e1)
end
function c59344077.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c59344077.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) then
		local sel=1
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_SPELL)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(59344077,0))
		if g:GetCount()>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			Duel.NegateEffect(0)
			return
		end
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
