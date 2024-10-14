--ダイガスタ・エメラル
---@param c Card
function c581014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--ret&draw&spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c581014.cost)
	e1:SetTarget(c581014.target1)
	e1:SetOperation(c581014.operation1)
	c:RegisterEffect(e1)
end
function c581014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c581014.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c581014.filter2(c,e,tp)
	return not c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c581014.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c581014.filter1(chkc)
		else
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c581014.filter2(chkc,e,tp)
		end
	end
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c581014.filter1,tp,LOCATION_GRAVE,0,3,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c581014.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(581014,1),aux.Stringid(581014,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(581014,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(581014,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c581014.filter1,tp,LOCATION_GRAVE,0,3,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c581014.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c581014.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==3 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
