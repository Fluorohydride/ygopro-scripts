--Dinomist Charge
function c77116346.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77116346+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c77116346.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77116346.condition)
	e2:SetTarget(c77116346.target)
	e2:SetOperation(c77116346.acop)
	c:RegisterEffect(e2)
end
function c77116346.dfilter(c)
	return c:IsSetCard(0x1e71) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77116346.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77116346.dfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c77116346.filter(c,e,tp)
	return c:IsSetCard(0x1e71) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsControler(tp)
end
function c77116346.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77116346.filter,1,nil,tp)
end
function c77116346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
end
function c77116346.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77116346.filter,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local rg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,rg)
end
