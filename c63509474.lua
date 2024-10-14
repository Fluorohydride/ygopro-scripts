--白の救済
---@param c Card
function c63509474.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63509474,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,63509474)
	e2:SetTarget(c63509474.thtg)
	e2:SetOperation(c63509474.thop)
	c:RegisterEffect(e2)
	--to hand or special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c63509474.condition)
	e3:SetTarget(c63509474.target)
	e3:SetOperation(c63509474.operation)
	c:RegisterEffect(e3)
end
function c63509474.thfilter(c)
	return c:IsRace(RACE_FISH) and c:IsAbleToHand()
end
function c63509474.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c63509474.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c63509474.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c63509474.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c63509474.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c63509474.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY)
		and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)
end
function c63509474.filter(c,e,tp,spchk)
	return c:IsRace(RACE_FISH) and (c:IsAbleToHand() or spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c63509474.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c63509474.filter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk)
	end
end
function c63509474.operation(e,tp,eg,ep,ev,re,r,rp)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c63509474.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if spchk and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end
