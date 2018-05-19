--アルティメット・バースト
function c43845801.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c43845801.condition)
	e1:SetTarget(c43845801.target)
	e1:SetOperation(c43845801.activate)
	c:RegisterEffect(e1)
end
c43845801.card_code_list={23995346}
function c43845801.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c43845801.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_FUSION)
		and c:IsCode(23995346) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c43845801.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43845801.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43845801.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c43845801.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c43845801.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(c43845801.aclimit)
		e2:SetCondition(c43845801.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c43845801.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end
function c43845801.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
