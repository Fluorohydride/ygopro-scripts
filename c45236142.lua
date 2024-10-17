--A宝玉獣 コバルト・イーグル
---@param c Card
function c45236142.initial_effect(c)
	aux.AddCodeList(c,12644061)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--self to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c45236142.tgcon)
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c45236142.repcon)
	e2:SetOperation(c45236142.repop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45236142,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCost(c45236142.thcost)
	e3:SetTarget(c45236142.thtg)
	e3:SetOperation(c45236142.thop)
	c:RegisterEffect(e3)
	--return deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(45236142,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c45236142.target)
	e4:SetOperation(c45236142.operation)
	c:RegisterEffect(e4)
end
function c45236142.tgcon(e)
	return not Duel.IsEnvironment(12644061)
end
function c45236142.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c45236142.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c45236142.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c45236142.thfilter(c)
	return c:IsCode(12644061) and c:IsAbleToHand()
end
function c45236142.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c45236142.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c45236142.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c45236142.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c45236142.filter(c)
	return c:IsSetCard(0x5034) and (c:IsAbleToHand() or c:IsAbleToDeck()) and c:IsFaceup()
end
function c45236142.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c45236142.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45236142.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c45236142.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if not g:GetFirst():IsAbleToHand() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	elseif not g:GetFirst():IsAbleToDeck() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c45236142.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsAbleToHand() and (not tc:IsAbleToDeck()
			or Duel.SelectOption(tp,aux.Stringid(45236142,2),aux.Stringid(45236142,3))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
