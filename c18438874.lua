--イービル・マインド
---@param c Card
function c18438874.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18438874,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18438874+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c18438874.condition)
	e1:SetTarget(c18438874.drtg)
	e1:SetOperation(c18438874.drop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18438874,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,18438874+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c18438874.condition)
	e2:SetTarget(c18438874.thtg1)
	e2:SetOperation(c18438874.thop1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18438874,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18438874+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c18438874.condition)
	e3:SetTarget(c18438874.thtg2)
	e3:SetOperation(c18438874.thop2)
	c:RegisterEffect(e3)
end
function c18438874.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c18438874.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18438874.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18438874.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18438874.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c18438874.thfilter1(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8) or c:IsCode(94820406))
end
function c18438874.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if chk==0 then return ct>=4 and Duel.IsExistingMatchingCard(c18438874.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18438874.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18438874.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18438874.thfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)
end
function c18438874.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if chk==0 then return ct>=10 and Duel.IsExistingMatchingCard(c18438874.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18438874.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18438874.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
