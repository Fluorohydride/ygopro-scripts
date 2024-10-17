--走破するガイア
---@param c Card
function c2106266.initial_effect(c)
	aux.AddCodeList(c,66889139)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	e1:SetCondition(c2106266.actcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2106266,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,2106266)
	e2:SetCost(c2106266.cost1)
	e2:SetTarget(c2106266.target1)
	e2:SetOperation(c2106266.activate1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(2106266,1))
	e3:SetCost(c2106266.cost2)
	e3:SetTarget(c2106266.target2)
	e3:SetOperation(c2106266.activate2)
	c:RegisterEffect(e3)
end
function c2106266.actfilter(c)
	return c:IsFaceup() and c:IsCode(66889139)
end
function c2106266.actcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c2106266.actfilter,tp,LOCATION_MZONE,0,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c2106266.costfilter1(c)
	return c:IsSetCard(0xbd) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c2106266.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2106266.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c2106266.costfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c2106266.thfilter1(c)
	return c:IsLevel(5) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c2106266.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2106266.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2106266.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2106266.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c2106266.costfilter2(c)
	return c:IsLevel(5) and c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c2106266.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2106266.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c2106266.costfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c2106266.thfilter2(c)
	return c:IsSetCard(0xbd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2106266.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2106266.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2106266.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2106266.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
