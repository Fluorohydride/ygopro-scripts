--デュエリスト・アドベント
function c37469904.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37469904+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c37469904.condition)
	e1:SetTarget(c37469904.target)
	e1:SetOperation(c37469904.activate)
	c:RegisterEffect(e1)
end
function c37469904.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0
end
function c37469904.filter(c)
	return c:IsSetCard(0xf2) and c:IsType(TYPE_PENDULUM+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c37469904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37469904.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37469904.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c37469904.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
