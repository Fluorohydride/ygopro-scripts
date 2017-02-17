--螺旋のストライクバースト
function c82768499.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c82768499.target)
	c:RegisterEffect(e1)
end
function c82768499.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x99)
end
function c82768499.thfilter(c)
	return c:IsSetCard(0x99) and c:GetLevel()==7 and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c82768499.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local b1=Duel.IsExistingMatchingCard(c82768499.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(c82768499.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(82768499,0),aux.Stringid(82768499,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(82768499,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(82768499,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		e:SetOperation(c82768499.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(c82768499.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		e:SetOperation(c82768499.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	end
end
function c82768499.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
function c82768499.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82768499.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
