--機甲部隊の再編制
function c86852702.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86852702,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86852702+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c86852702.cost)
	e1:SetTarget(c86852702.target)
	e1:SetOperation(c86852702.activate)
	c:RegisterEffect(e1)
end
function c86852702.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c86852702.costfilter(c)
	return c:IsSetCard(0x36) and c:IsDiscardable()
end
function c86852702.thfilter1(c)
	return c:IsSetCard(0x36) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c86852702.thfilter2(c)
	return c:IsSetCard(0x36) and not c:IsCode(86852702) and c:IsAbleToHand()
end
function c86852702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local count1=Duel.GetMatchingGroup(c86852702.thfilter1,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local count2=Duel.GetMatchingGroup(c86852702.thfilter2,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) and count1>=2
	local b2=Duel.IsExistingMatchingCard(c86852702.costfilter,tp,LOCATION_HAND,0,1,c) and count2>=2
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return b1 or b2
		else
			return count1>=2 or count2>=2
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(86852702,0),aux.Stringid(86852702,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(86852702,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(86852702,1))+1
		end
		if op==0 then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
		else
			Duel.DiscardHand(tp,c86852702.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
		end
		e:SetLabel(0,op)
	else
		local op=0
		if count1>=2 and count2>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(86852702,0),aux.Stringid(86852702,1))
		elseif count1>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(86852702,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(86852702,1))+1
		end
		e:SetLabel(0,op)
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c86852702.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,op=e:GetLabel()
	if op==0 then
		local g=Duel.GetMatchingGroup(c86852702.thfilter1,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if hg then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	else
		local g=Duel.GetMatchingGroup(c86852702.thfilter2,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if hg then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end
