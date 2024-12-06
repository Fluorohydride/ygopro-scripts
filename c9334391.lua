--宝玉の絆
---@param c Card
function c9334391.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9334391+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9334391.target)
	e1:SetOperation(c9334391.activate)
	c:RegisterEffect(e1)
end
function c9334391.thfilter(c,tp)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9334391.plfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c9334391.plfilter(c,code)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsCanBePlacedOnField()
end
function c9334391.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingMatchingCard(c9334391.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9334391.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9334391.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0
		and g1:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g1)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g2=Duel.SelectMatchingCard(tp,c9334391.plfilter,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetCode())
		local tc=g2:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
		end
	end
end
