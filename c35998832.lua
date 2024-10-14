--溟界の漠－ゾーハ
---@param c Card
function c35998832.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35998832,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,35998832)
	e1:SetCondition(c35998832.drcon)
	e1:SetTarget(c35998832.drtg)
	e1:SetOperation(c35998832.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c35998832.drcon2)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35998832,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,35998833)
	e3:SetCost(c35998832.thcost)
	e3:SetTarget(c35998832.thtg)
	e3:SetOperation(c35998832.thop)
	c:RegisterEffect(e3)
end
function c35998832.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c35998832.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c35998832.drfilter(c)
	return not c:IsCode(35998832) and c:IsSetCard(0x161) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c35998832.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.IsExistingMatchingCard(c35998832.drfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c35998832.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c35998832.drfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local turnp=Duel.GetTurnPlayer()
			local tg1=Duel.GetFieldGroup(turnp,LOCATION_HAND,0)
			local tg2=Duel.GetFieldGroup(1-turnp,LOCATION_HAND,0)
			if tg1:GetCount()<1 or tg2:GetCount()<1 then return end
			Duel.BreakEffect()
			Duel.ShuffleHand(turnp)
			Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
			local tc1=tg1:Select(turnp,1,1,nil):GetFirst()
			Duel.SendtoGrave(tc1,REASON_EFFECT)
			Duel.ShuffleHand(1-turnp)
			Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
			local tc2=tg2:Select(1-turnp,1,1,nil):GetFirst()
			Duel.SendtoGrave(tc2,REASON_EFFECT)
		end
	end
end
function c35998832.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c35998832.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c35998832.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
