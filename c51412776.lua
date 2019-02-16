--Heritage of the Chalice
function c51412776.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51412776)
	e1:SetTarget(c51412776.target)
	e1:SetOperation(c51412776.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(c51412776.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+51412776)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,51412776)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c51412776.thtg)
	e3:SetOperation(c51412776.thop)
	c:RegisterEffect(e3)
end
function c51412776.filter(c)
	return ((c:IsSetCard(0x107a) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x207a)) and c:IsAbleToHand()
end
function c51412776.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51412776.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c51412776.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51412776.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c51412776.checkfilter(c)
	return c:IsSetCard(0x107a) and c:IsReason(REASON_BATTLE) and c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x207a)
end
function c51412776.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c51412776.checkfilter,1,nil) then Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+51412776,nil,0,rp,ep,ev) end
end
function c51412776.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51412776.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
