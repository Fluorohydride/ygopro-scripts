--エクスピュアリィ・ノアール
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.imecon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--card to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.tdcon1)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.tdcon2)
	c:RegisterEffect(e3)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(2) and c:GetOverlayCount()>=5
end
function s.imecon(e)
	return e:GetHandler():GetOverlayCount()>=5
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.check(c)
	return c:IsSetCard(0x18c) and c:IsLevel(1)
end
function s.tdcon1(e)
	return not e:GetHandler():GetOverlayGroup():IsExists(s.check,1,nil)
end
function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(s.check,1,nil)
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=aux.SelectCardFromFieldFirst(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
