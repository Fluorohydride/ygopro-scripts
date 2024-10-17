--慧炎星－コサンジャク
---@param c Card
function c20265095.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x79),2,2)
	--cannot battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c20265095.btcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20265095,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,20265095)
	e2:SetCost(c20265095.ctcost)
	e2:SetTarget(c20265095.cttg)
	e2:SetOperation(c20265095.ctop)
	c:RegisterEffect(e2)
end
function c20265095.btfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x79)
end
function c20265095.btcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c20265095.btfilter,1,nil)
end
function c20265095.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c20265095.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20265095.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsPlayerAffectedByEffect(tp,46241344) end
	if Duel.IsExistingMatchingCard(c20265095.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c20265095.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c20265095.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged(false,zone) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil,false,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil,false,zone)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c20265095.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(c:GetLinkedZone(),0x1f)
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1,zone)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
