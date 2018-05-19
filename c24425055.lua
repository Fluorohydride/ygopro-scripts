--ブービートラップE
function c24425055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24425055.cost)
	e1:SetOperation(c24425055.activate)
	c:RegisterEffect(e1)
end
function c24425055.filter1(c,tp)
	return c:IsDiscardable() and ((c24425055.filter2(c) and c:IsAbleToGraveAsCost())
		or Duel.IsExistingMatchingCard(c24425055.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c))
end
function c24425055.filter2(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsSSetable()
end
function c24425055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24425055.filter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,c24425055.filter1,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function c24425055.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24425055.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
