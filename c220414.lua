--EMターントルーパー
---@param c Card
function c220414.initial_effect(c)
	c:EnableCounterPermit(0x50)
	c:SetCounterLimit(0x50,2)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(220414,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c220414.ctcon)
	e1:SetTarget(c220414.cttg)
	e1:SetOperation(c220414.ctop)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(220414,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c220414.negcon)
	e2:SetOperation(c220414.negop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(220414,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c220414.rmcon)
	e3:SetCost(c220414.rmcost)
	e3:SetTarget(c220414.rmtg)
	e3:SetOperation(c220414.rmop)
	c:RegisterEffect(e3)
end
function c220414.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c220414.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x50,1) end
end
function c220414.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x50,1)
	end
end
function c220414.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and e:GetHandler():GetCounter(0x50)==1
end
function c220414.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c220414.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x50)==2
end
function c220414.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c220414.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c220414.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local c=e:GetHandler()
		local og=Duel.GetOperatedGroup()
		local fid=c:GetFieldID()
		local tc=og:GetFirst()
		while tc do
			tc:RegisterFlagEffect(220414,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2,fid)
			tc=og:GetNext()
		end
		c:SetTurnCounter(0)
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c220414.retcon)
		e1:SetOperation(c220414.retop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c220414.retfilter(c,fid)
	return c:GetFlagEffectLabel(220414)==fid
end
function c220414.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c220414.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c220414.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		local g=e:GetLabelObject()
		local sg=g:Filter(c220414.retfilter,nil,e:GetLabel())
		g:DeleteGroup()
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end
