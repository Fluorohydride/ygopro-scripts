--サイバネット・コンフリクト
function c7403341.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,7403341+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c7403341.condition)
	e1:SetTarget(c7403341.target)
	e1:SetOperation(c7403341.activate)
	c:RegisterEffect(e1)
end
function c7403341.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x101)
end
function c7403341.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c7403341.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c7403341.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c7403341.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c7403341.aclimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7403341.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:GetOriginalCode()==tc:GetOriginalCode() and not c:IsImmuneToEffect(e)
end
