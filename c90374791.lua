--アームド・チェンジャー
function c90374791.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,c90374791.cost)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90374791,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c90374791.thcon)
	e3:SetTarget(c90374791.thtg)
	e3:SetOperation(c90374791.thop)
	c:RegisterEffect(e3)
end
function c90374791.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c90374791.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90374791.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c90374791.cfilter,1,1,REASON_COST)
end
function c90374791.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c90374791.filter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(atk) and c:IsAbleToHand()
end
function c90374791.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local eatk=e:GetHandler():GetEquipTarget():GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90374791.filter(chkc,eatk) end
	if chk==0 then return Duel.IsExistingTarget(c90374791.filter,tp,LOCATION_GRAVE,0,1,nil,eatk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c90374791.filter,tp,LOCATION_GRAVE,0,1,1,nil,eatk)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c90374791.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
