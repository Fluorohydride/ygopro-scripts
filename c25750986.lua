--エターナル・カオス
---@param c Card
function c25750986.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,25750986+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c25750986.target)
	e1:SetOperation(c25750986.activate)
	c:RegisterEffect(e1)
end
function c25750986.tfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c25750986.tgfilter,tp,LOCATION_DECK,0,1,c,tp,c:GetAttack())
end
function c25750986.tgfilter(c,tp,atk)
	return c:IsAttackBelow(atk) and c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c25750986.tgfilter1,tp,LOCATION_DECK,0,1,c,atk-c:GetAttack(),c:GetAttribute())
end
function c25750986.tgfilter1(c,atk,att)
	return c:IsAttackBelow(atk) and c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsAttribute(att)
end
function c25750986.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c25750986.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c25750986.tfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c25750986.tfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c25750986.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c25750986.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp,atk)
		local gc=g:GetFirst()
		if gc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c25750986.tgfilter1,tp,LOCATION_DECK,0,1,1,gc,atk-gc:GetAttack(),gc:GetAttribute())
			g:Merge(g1)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c25750986.actcon)
		e1:SetValue(c25750986.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c25750986.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c25750986.actcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),25750986)~=0
end
function c25750986.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_GRAVE
end
function c25750986.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) or not re:GetActivateLocation()==LOCATION_GRAVE then return end
	Duel.RegisterFlagEffect(tp,25750986,RESET_PHASE+PHASE_END,0,1)
end
