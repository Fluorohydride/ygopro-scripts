--魅惑の未界域
function c57433966.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,57433966+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c57433966.cost)
	e1:SetTarget(c57433966.target)
	e1:SetOperation(c57433966.activate)
	c:RegisterEffect(e1)
end
function c57433966.cfilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x11e) and c:IsDiscardable()
end
function c57433966.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57433966.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c57433966.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c57433966.thfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x11e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c57433966.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57433966.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c57433966.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c57433966.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c57433966.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c57433966.splimit(e,c)
	return not c:IsSetCard(0x11e)
end
