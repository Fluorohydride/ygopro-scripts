--Hi Speed Re-Level
function c15555120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c15555120.cost)
	e1:SetTarget(c15555120.target)
	e1:SetOperation(c15555120.activate)
	c:RegisterEffect(e1)
end
function c15555120.cfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
end
function c15555120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15555120.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=Duel.SelectMatchingCard(tp,c15555120.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(rg:GetFirst())
	rg:GetFirst():CreateEffectRelation(e)
end
function c15555120.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c15555120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c15555120.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15555120.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c15555120.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c15555120.activate(e,tp,eg,ep,ev,re,r,rp)
	local lc=e:GetLabelObject()
	if not lc:IsRelateToEffect(e) then return end
	local lv=lc:GetLevel()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(lv*500)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
