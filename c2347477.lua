--マイクロ・コーダー
function c2347477.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2347477)
	e1:SetValue(c2347477.matval)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2347477,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,2347478)
	e3:SetCondition(c2347477.thcon)
	e3:SetTarget(c2347477.thtg)
	e3:SetOperation(c2347477.thop)
	c:RegisterEffect(e3)
end
function c2347477.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE) and c:IsControler(tp)
end
function c2347477.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(2347477)
end
function c2347477.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x101) then return false,nil end
	return true,not mg or mg:IsExists(c2347477.mfilter,1,nil,tp) and not mg:IsExists(c2347477.exmfilter,1,nil)
end
function c2347477.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101) then
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			e:SetLabel(1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(2347477,1))
		end
		return true
	else
		return false
	end
end
function c2347477.thfilter(c,chk)
	return ((c:IsSetCard(0x118) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (chk==1 and c:IsRace(RACE_CYBERSE) and c:IsLevel(4))) and c:IsAbleToHand()
end
function c2347477.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2347477.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2347477.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2347477.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
