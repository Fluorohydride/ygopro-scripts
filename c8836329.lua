--颶風龍－ビュフォート・ノウェム
---@param c Card
function c8836329.initial_effect(c)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8836329,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8836329)
	e1:SetCondition(c8836329.discon)
	e1:SetCost(c8836329.discost)
	e1:SetTarget(c8836329.distg)
	e1:SetOperation(c8836329.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8836329,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,8836330)
	e2:SetTarget(c8836329.thtg)
	e2:SetOperation(c8836329.thop)
	c:RegisterEffect(e2)
end
function c8836329.discon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(Duel.GetAttacker())
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c8836329.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c8836329.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function c8836329.disop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if Duel.NegateAttack() and bc and bc:IsRelateToBattle() and bc:IsFaceup() and not bc:IsDisabled() then
		Duel.NegateRelatedChain(bc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e2)
	end
end
function c8836329.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c8836329.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c8836329.thfilter(chkc) end
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingTarget(c8836329.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c8836329.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c8836329.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local rg=Group.FromCards(c,tc)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
end
