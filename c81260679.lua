--オオヒメの御巫
function c81260679.initial_effect(c)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81260679,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81260679)
	e1:SetCost(c81260679.thcost)
	e1:SetTarget(c81260679.thtg)
	e1:SetOperation(c81260679.thop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81260679,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,81260680)
	e4:SetTarget(c81260679.eqtg)
	e4:SetOperation(c81260679.eqop)
	c:RegisterEffect(e4)
end
function c81260679.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c81260679.thfilter(c)
	return c:IsSetCard(0x18d) and not c:IsCode(81260679) and c:IsAbleToHand()
end
function c81260679.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81260679.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c81260679.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81260679.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c81260679.filter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.GetMatchingGroupCount(c81260679.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)>0
end
function c81260679.eqfilter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c81260679.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81260679.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c81260679.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c81260679.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c81260679.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c81260679.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		Duel.Equip(tp,tc,sg:GetFirst())
	end
end
