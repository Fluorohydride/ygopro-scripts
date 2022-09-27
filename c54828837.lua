--失楽の霹靂
function c54828837.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--alternate summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(54828837)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c54828837.negcon)
	e3:SetOperation(c54828837.negop)
	c:RegisterEffect(e3)
	--damage protection
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(54828837,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c54828837.protcon)
	e4:SetOperation(c54828837.protop)
	c:RegisterEffect(e4)
end
function c54828837.cfilter(c)
	return c:IsFaceup() and c:IsCode(32491822) and c:IsAttackPos()
end
function c54828837.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c54828837.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
		and e:GetHandler():GetFlagEffect(54828837)<=0
end
function c54828837.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,54828837)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c54828837.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,c54828837.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
		c:RegisterFlagEffect(54828837,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c54828837.protfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and (c:GetPreviousCodeOnField()==32491822 or c:GetPreviousCodeOnField()==6007213 or c:GetPreviousCodeOnField()==69890967)
end
function c54828837.protcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c54828837.protfilter,1,nil,tp)
end
function c54828837.protop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
