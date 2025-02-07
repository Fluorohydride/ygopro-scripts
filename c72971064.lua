--LL－アンサンブルー・ロビン
function c72971064.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c72971064.atkval)
	c:RegisterEffect(e1)
	--to hand
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,72971064,EVENT_SPSUMMON_SUCCESS)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72971064,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c72971064.thcon)
	e2:SetCost(c72971064.thcost)
	e2:SetTarget(c72971064.thtg)
	e2:SetOperation(c72971064.thop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72971064,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(c72971064.recon)
	e3:SetTarget(c72971064.retg)
	e3:SetOperation(c72971064.reop)
	c:RegisterEffect(e3)
end
function c72971064.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c72971064.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c72971064.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72971064.thfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAbleToHand()
end
function c72971064.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c72971064.thfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c72971064.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c72971064.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function c72971064.filter2(c)
	return c:IsSetCard(0xf7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72971064.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c72971064.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c72971064.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c72971064.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c72971064.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
