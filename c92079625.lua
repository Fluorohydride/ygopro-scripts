--影依の炎核 ヴォイド
function c92079625.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92079625,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,92079625)
	e1:SetTarget(c92079625.target)
	e1:SetOperation(c92079625.operation)
	c:RegisterEffect(e1)
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92079625,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,92079625)
	e2:SetCondition(c92079625.tgcon)
	e2:SetTarget(c92079625.tgtg)
	e2:SetOperation(c92079625.tgop)
	c:RegisterEffect(e2)
	c92079625.shadoll_flip_effect=e1
end
function c92079625.cfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c92079625.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute())
end
function c92079625.tgfilter(c,att)
	return c:IsAbleToGrave() and c:IsAttribute(att) and c:IsSetCard(0x9d)
end
function c92079625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c92079625.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c92079625.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c92079625.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c92079625.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c92079625.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,att)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c92079625.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c92079625.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetOriginalAttribute)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c92079625.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetOriginalAttribute)
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
