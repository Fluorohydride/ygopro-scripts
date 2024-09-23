--覚醒の三幻魔
function c53701259.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(1)
	e2:SetCondition(c53701259.lpcon)
	e2:SetOperation(c53701259.lpop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(1)
	e3:SetCondition(c53701259.lpcon1)
	e3:SetOperation(c53701259.lpop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(1)
	e4:SetCondition(c53701259.regcon)
	e4:SetOperation(c53701259.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c53701259.lpcon2)
	e5:SetOperation(c53701259.lpop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(2)
	e6:SetCondition(c53701259.discon)
	e6:SetOperation(c53701259.disop)
	c:RegisterEffect(e6)
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetValue(LOCATION_REMOVED)
	e7:SetTargetRange(0,LOCATION_DECK)
	e7:SetTarget(c53701259.rmtg)
	e7:SetCondition(c53701259.rmcon)
	c:RegisterEffect(e7)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(53701259,0))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c53701259.thcon)
	e8:SetTarget(c53701259.thtg)
	e8:SetOperation(c53701259.thop)
	c:RegisterEffect(e8)
end
function c53701259.filter(c)
	return c:IsFaceup() and c:IsCode(6007213,32491822,69890967)
end
function c53701259.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup()
end
function c53701259.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53701259.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct=e:GetLabel()
	return ct and g:GetClassCount(Card.GetCode)>=ct
end
function c53701259.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return c53701259.condition(e,tp,eg,ep,ev,re,r,rp)
		and eg:IsExists(c53701259.cfilter,1,nil,1-tp)
end
function c53701259.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return c53701259.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and not Duel.IsChainSolving()
end
function c53701259.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c53701259.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function c53701259.regcon(e,tp,eg,ep,ev,re,r,rp)
	return c53701259.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsChainSolving()
end
function c53701259.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c53701259.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	e:GetHandler():RegisterFlagEffect(53701259,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function c53701259.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53701259)>0
end
function c53701259.lpop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(53701259)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function c53701259.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return c53701259.condition(e,tp,eg,ep,ev,re,r,rp)
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rp==1-tp
end
function c53701259.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c53701259.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and aux.DimensionalFissureTarget(e,c)
end
function c53701259.rmcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c53701259.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)==3
end
function c53701259.ffilter(c)
	return c:IsFaceup() and c:IsLevel(10)
end
function c53701259.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53701259.ffilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c53701259.thfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c53701259.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53701259.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c53701259.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c53701259.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
