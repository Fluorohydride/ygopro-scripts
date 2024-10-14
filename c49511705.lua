--銃砲撃
---@param c Card
function c49511705.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49511705.regcon)
	e2:SetOperation(c49511705.regop)
	c:RegisterEffect(e2)
	--coin result
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49511705,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c49511705.coincon1)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c49511705.coinop1)
	c:RegisterEffect(e3)
end
function c49511705.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	return ex
end
function c49511705.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c49511705.effcon)
	e1:SetOperation(c49511705.effop)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	c:RegisterEffect(e1)
end
function c49511705.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c49511705.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49511705)
	local ct=0
	local res={Duel.GetCoinResult()}
	for i=1,ev do
		if res[i]==1 then
			ct=ct+1
		end
	end
	if ct>0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if ct>2 then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()>0 then
			Duel.ConfirmCards(tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local sg=hg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			Duel.ShuffleHand(1-tp)
		end
	end
end
function c49511705.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c49511705.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c49511705.coincon2)
	e1:SetOperation(c49511705.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c49511705.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c49511705.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49511705)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
