--風霊術－「雅」
function c79333300.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c79333300.cost)
	e1:SetTarget(c79333300.target)
	e1:SetOperation(c79333300.activate)
	c:RegisterEffect(e1)
end
function c79333300.tdfilter(c,tc)
	return c:GetEquipTarget()~=tc and c:IsAbleToDeck()
end
function c79333300.costfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and (c:IsFaceup() or c:IsControler(tp))
		and Duel.IsExistingTarget(c79333300.tdfilter,tp,0,LOCATION_ONFIELD,1,c,c)
end
function c79333300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c79333300.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c79333300.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c79333300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return e:IsCostChecked()
		or Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c79333300.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
