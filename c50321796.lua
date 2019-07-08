--氷結界の龍 ブリューナク
function c50321796.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50321796,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50321796)
	e1:SetCost(c50321796.cost)
	e1:SetTarget(c50321796.target)
	e1:SetOperation(c50321796.operation)
	c:RegisterEffect(e1)
end
function c50321796.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c50321796.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rt=Duel.GetTargetCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if rt==0 then return false end
		local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_COST,1,rt)
		return max>0 and Duel.CheckDiscardHand(tp,c50321796.costfilter,1,REASON_DISCARD+REASON_COST)
	end
	local min,max=Duel.GetDiscardHandChangeCount(tp,REASON_COST,1,rt)
	if min<=0 then min=1 end
	local ct=Duel.DiscardHand(tp,c50321796.costfilter,min,max,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c50321796.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
end
function c50321796.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
