--星遺物の選託
function c59778096.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59778096+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c59778096.target)
	e1:SetOperation(c59778096.activate)
	c:RegisterEffect(e1)
end
function c59778096.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c59778096.rmfilter(c)
	return c:IsSetCard(0xfe) and c:IsAbleToRemoveAsCost()
end
function c59778096.thfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function c59778096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c59778096.tgfilter,tp,0,LOCATION_MZONE,1,nil)
	local b2=(not e:IsCostChecked() or Duel.IsExistingMatchingCard(c59778096.rmfilter,tp,LOCATION_GRAVE,0,7,nil))
		and Duel.IsExistingMatchingCard(c59778096.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(59778096,0),aux.Stringid(59778096,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(59778096,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(59778096,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(c59778096.tgfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		if e:IsCostChecked() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c59778096.rmfilter,tp,LOCATION_GRAVE,0,7,7,nil)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c59778096.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c59778096.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c59778096.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
