--ネオフレムベル・レディ
function c816427.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(816427,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,816427)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c816427.rmcost)
	e1:SetTarget(c816427.rmtg)
	e1:SetOperation(c816427.rmop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(816427,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,816428)
	e2:SetCondition(c816427.tgcon)
	e2:SetTarget(c816427.tgtg)
	e2:SetOperation(c816427.tgop)
	c:RegisterEffect(e2)
end
function c816427.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost()
end
function c816427.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c816427.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c816427.costfilter,1,1,REASON_COST)
end
function c816427.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c816427.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c816427.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==1-tp
end
function c816427.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c816427.cfilter,1,nil,tp)
end
function c816427.tgfilter(c)
	return c:IsDefenseBelow(200) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(816427) and c:IsAbleToGrave()
end
function c816427.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c816427.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c816427.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c816427.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
