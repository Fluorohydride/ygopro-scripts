--メタファイズ・ネフティス
function c72355272.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72355272,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c72355272.rmcon)
	e1:SetTarget(c72355272.rmtg)
	e1:SetOperation(c72355272.rmop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72355272,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c72355272.thcon)
	e2:SetCost(c72355272.thcost)
	e2:SetTarget(c72355272.thtg)
	e2:SetOperation(c72355272.thop)
	c:RegisterEffect(e2)
end
function c72355272.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x105)
end
function c72355272.rmfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c72355272.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c72355272.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c72355272.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72355272.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c72355272.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c72355272.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c72355272.thfilter(c)
	return c:IsSetCard(0x105) and not c:IsCode(72355272) and c:IsAbleToHand()
end
function c72355272.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72355272.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72355272.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72355272.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
