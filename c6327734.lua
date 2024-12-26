--珠の御巫フゥリ
---@param c Card
function c6327734.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c6327734.ndcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c6327734.indcon)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c6327734.tgcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x18d))
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6327734,0))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_EQUIP)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,6327734)
	e5:SetTarget(c6327734.thtg)
	e5:SetOperation(c6327734.thop)
	c:RegisterEffect(e5)
end
function c6327734.ndcon(e)
	return e:GetHandler():GetEquipCount()==0
end
function c6327734.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c6327734.indcfilter(c)
	return c:GetEquipTarget() or (c:IsFaceup() and c:IsType(TYPE_EQUIP))
end
function c6327734.tgcon(e)
	return Duel.IsExistingMatchingCard(c6327734.indcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c6327734.thfilter(c)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c6327734.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6327734.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6327734.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6327734.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
