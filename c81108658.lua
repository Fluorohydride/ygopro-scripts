--ベアルクティ－メガビリス
---@param c Card
function c81108658.initial_effect(c)
	--spsummon
	local e1=aux.AddUrsarcticSpSummonEffect(c)
	e1:SetDescription(aux.Stringid(81108658,0))
	e1:SetCountLimit(1,81108658)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81108658,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81108659)
	e2:SetCondition(c81108658.rmcon)
	e2:SetTarget(c81108658.rmtg)
	e2:SetOperation(c81108658.rmop)
	c:RegisterEffect(e2)
end
function c81108658.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x163)
end
function c81108658.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81108658.confilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c81108658.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81108658.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
