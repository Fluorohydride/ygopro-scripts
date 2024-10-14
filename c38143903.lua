--ヘッド・ジャッジング
---@param c Card
function c38143903.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(38143903,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCondition(aux.dscon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38143903,1))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_NEGATE+CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,38143903)
	e1:SetCondition(c38143903.negcon)
	e1:SetTarget(c38143903.negtg)
	e1:SetOperation(c38143903.negop)
	c:RegisterEffect(e1)
	--negate
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
end
c38143903.toss_coin=true
function c38143903.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
end
function c38143903.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave()
		and (not re:GetHandler():IsRelateToEffect(re) or re:GetHandler():IsAbleToChangeControler()) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,ep,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c38143903.negop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(p)
	local res=Duel.TossCoin(p,1)
	if coin==res then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.GetControl(re:GetHandler(),1-p)
		end
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
