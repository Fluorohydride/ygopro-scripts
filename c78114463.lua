--神の密告
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.accon)
	e2:SetCost(s.accost)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLPCost(tp,1500)
	local b2=Duel.CheckLPCost(tp,3000) and Duel.IsPlayerCanRemove(tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		Duel.PayLPCost(tp,1500)
	elseif op==2 then
		Duel.PayLPCost(tp,3000)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=true
	local b2=Duel.IsPlayerCanRemove(tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local op=0
	if not e:IsCostChecked() then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	else
		op=e:GetLabel()
	end
	e:SetLabel(op)
	if op==1 then
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	else
		if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
	end
end
function s.rmfilter(c,tp,tc)
	return c:IsAbleToRemove(tp) and c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToChain(ev)
			and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,1)
			e1:SetValue(s.aclimit)
			e1:SetLabelObject(re:GetHandler())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	elseif e:GetLabel()==2 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToChain(ev)
			and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_HAND+LOCATION_DECK,nil,1-tp,re:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT,1-tp)
			end
		end
	end
end
function s.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.accon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_TRAP)
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
end
