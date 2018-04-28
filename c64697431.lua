--局所的ハリケーン
function c64697431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c64697431.target)
	e1:SetOperation(c64697431.activate)
	c:RegisterEffect(e1)
end
function c64697431.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c64697431.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c64697431.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c64697431.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c64697431.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c64697431.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
