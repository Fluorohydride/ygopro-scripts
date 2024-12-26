--武装鍛錬
---@param c Card
function c27979109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27979109,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,27979109)
	e2:SetCondition(c27979109.thcon)
	e2:SetTarget(c27979109.thtg)
	e2:SetOperation(c27979109.thop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27979109,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,27979110)
	e3:SetCondition(c27979109.drcon)
	e3:SetCost(c27979109.drcost)
	e3:SetTarget(c27979109.drtg)
	e3:SetOperation(c27979109.drop)
	c:RegisterEffect(e3)
end
c27979109.has_text_type=TYPE_DUAL
function c27979109.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c27979109.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c27979109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(c27979109.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	aux.GiveUpNormalDraw(e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c27979109.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27979109.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c27979109.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c27979109.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27979109.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c27979109.costfilter(c)
	return ((c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)) or c:IsType(TYPE_DUAL)) and c:IsAbleToDeckAsCost()
end
function c27979109.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27979109.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c27979109.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c27979109.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27979109.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
