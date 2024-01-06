--イービル・マインド
function c18438874.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18438874+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c18438874.condition)
	e1:SetTarget(c18438874.target)
	e1:SetOperation(c18438874.activate)
	c:RegisterEffect(e1)
end
function c18438874.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c18438874.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18438874.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18438874.thfilter1(c)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8) or c:IsCode(94820406)) and c:IsAbleToHand()
end
function c18438874.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c18438874.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local b1=Duel.IsPlayerCanDraw(tp,1) and ct>0
	local b2=Duel.IsExistingMatchingCard(c18438874.thfilter1,tp,LOCATION_DECK,0,1,nil) and ct>3
	local b3=Duel.IsExistingMatchingCard(c18438874.thfilter2,tp,LOCATION_DECK,0,1,nil) and ct>9
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(18438874,0)},
		{b2,aux.Stringid(18438874,1)},
		{b3,aux.Stringid(18438874,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c18438874.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c18438874.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c18438874.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
