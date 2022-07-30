--怪鳥グライフ
function c899287.initial_effect(c)
	aux.AddCodeList(c,72283691)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(899287,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c899287.thcost)
	e1:SetTarget(c899287.thtg)
	e1:SetOperation(c899287.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(899287,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,899287)
	e2:SetTarget(c899287.destg)
	e2:SetOperation(c899287.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c899287.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c899287.thfilter(c)
	return c:IsCode(72283691) and c:IsAbleToHand()
end
function c899287.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c899287.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c899287.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c899287.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c899287.desfilter(c)
	return c:GetSequence()<5
end
function c899287.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c899287.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c899287.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c899287.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c899287.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
