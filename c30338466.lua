--剣現する武神
function c30338466.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c30338466.target)
	e1:SetOperation(c30338466.activate)
	c:RegisterEffect(e1)
end
function c30338466.filter(c)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30338466.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER)
end
function c30338466.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c30338466.filter(chkc)
		else
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c30338466.filter2(chkc)
		end
	end
	local b1=Duel.IsExistingTarget(c30338466.filter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingTarget(c30338466.filter2,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(30338466,0),aux.Stringid(30338466,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(30338466,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(30338466,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c30338466.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SelectTarget(tp,c30338466.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	end
end
function c30338466.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end
