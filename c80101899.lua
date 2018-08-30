--トラップトリック
function c80101899.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80101899+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80101899.target)
	e1:SetOperation(c80101899.activate)
	c:RegisterEffect(e1)
end
function c80101899.rmfilter(c,tp)
	return c:GetType()==TYPE_TRAP and not c:IsCode(80101899) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c80101899.setfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c80101899.setfilter(c,code)
	return c:IsCode(code) and c:IsSSetable()
end
function c80101899.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80101899.rmfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c80101899.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c80101899.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g2=Duel.SelectMatchingCard(tp,c80101899.setfilter,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode())
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.SSet(tp,tc2)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c80101899.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_NEGATED)
		e3:SetOperation(c80101899.aclimit2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetTargetRange(1,0)
		e4:SetCondition(c80101899.actcon)
		e4:SetValue(c80101899.aclimit3)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c80101899.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return end
	Duel.RegisterFlagEffect(tp,80101899,RESET_PHASE+PHASE_END,0,1)
end
function c80101899.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return end
	Duel.ResetFlagEffect(tp,80101899)
end
function c80101899.actcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),80101899)~=0
end
function c80101899.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
