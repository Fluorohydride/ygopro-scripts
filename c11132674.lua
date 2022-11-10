--ギガンティック“チャンピオン”サルガス
function c11132674.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c11132674.ovfilter,aux.Stringid(11132674,0),99,c11132674.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11132674,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11132674)
	e1:SetCondition(c11132674.srcon)
	e1:SetTarget(c11132674.srtg)
	e1:SetOperation(c11132674.srop)
	c:RegisterEffect(e1)
	--destroy or to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11132674,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11132675)
	e2:SetCondition(c11132674.descon)
	e2:SetTarget(c11132674.destg)
	e2:SetOperation(c11132674.desop)
	c:RegisterEffect(e2)
end
function c11132674.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x155) and c:IsType(TYPE_XYZ)
end
function c11132674.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11132674)==0 end
	Duel.RegisterFlagEffect(tp,11132674,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11132674.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c11132674.srfilter(c)
	return c:IsSetCard(0x155,0x179) and c:IsAbleToHand()
end
function c11132674.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11132674.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11132674.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11132674.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11132674.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end
function c11132674.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c11132674.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand()
		and Duel.SelectOption(tp,aux.Stringid(11132674,3),aux.Stringid(11132674,4))==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
