--月光黒羊
function c11317977.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11317977,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c11317977.cost1)
	e1:SetTarget(c11317977.target1)
	e1:SetOperation(c11317977.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11317977,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetLabel(2)
	e2:SetCondition(c11317977.condition2)
	e2:SetTarget(c11317977.target2)
	e2:SetOperation(c11317977.operation)
	c:RegisterEffect(e2)
end
function c11317977.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11317977.filter1(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf)
		and not c:IsCode(11317977) and c:IsAbleToHand()
end
function c11317977.filter2(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c11317977.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11317977.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c11317977.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(11317977,2),aux.Stringid(11317977,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(11317977,2))
	else op=Duel.SelectOption(tp,aux.Stringid(11317977,3))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c11317977.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	local op=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if op==0 then
		g=Duel.SelectMatchingCard(tp,c11317977.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	elseif op==1 then
		g=Duel.SelectMatchingCard(tp,c11317977.filter2,tp,LOCATION_DECK,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,c11317977.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	end
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11317977.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function c11317977.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11317977.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
