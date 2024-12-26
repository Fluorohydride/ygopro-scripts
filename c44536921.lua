--捕食計画
---@param c Card
function c44536921.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,44536921)
	e1:SetCost(c44536921.cost)
	e1:SetTarget(c44536921.target)
	e1:SetOperation(c44536921.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,44536922)
	e2:SetCondition(c44536921.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c44536921.destg)
	e2:SetOperation(c44536921.desop)
	c:RegisterEffect(e2)
end
function c44536921.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10f3) and c:IsAbleToGraveAsCost()
end
function c44536921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44536921.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c44536921.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c44536921.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1041,1) end
end
function c44536921.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1041,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1041,1)
		if tc:IsLevelAbove(2) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c44536921.lvcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c44536921.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end
function c44536921.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsSummonPlayer(tp)
end
function c44536921.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44536921.cfilter,1,nil,tp)
end
function c44536921.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c44536921.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
