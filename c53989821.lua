--SPYRAL GEAR - Utility Wire
function c53989821.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53989821+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c53989821.condition)
	e1:SetTarget(c53989821.target)
	e1:SetOperation(c53989821.activate)
	c:RegisterEffect(e1)
end
function c53989821.cfilter(c)
	return c:IsFaceup() and c:IsCode(41091257)
end
function c53989821.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53989821.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c53989821.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c53989821.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c53989821.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53989821.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c53989821.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c53989821.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
