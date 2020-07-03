--禁じられた一滴
function c24299458.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,24299458+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c24299458.cost)
	e1:SetTarget(c24299458.target)
	e1:SetOperation(c24299458.activate)
	c:RegisterEffect(e1)
end
function c24299458.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c24299458.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c24299458.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c24299458.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,dg:GetCount(),e:GetHandler())
	local tc=cg:GetFirst()
	local ctype=0
	while tc do
		for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
		end
		tc=cg:GetNext()
	end
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoGrave(cg,REASON_COST)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c24299458.chlimit(ctype))
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,cg:GetCount(),0,0)
end
function c24299458.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
function c24299458.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c24299458.filter,tp,0,LOCATION_MZONE,count,count,nil)
	if g:GetCount()==count then
		Duel.HintSelection(g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			local atk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e1)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end
