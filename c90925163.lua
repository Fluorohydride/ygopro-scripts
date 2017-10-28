--踊る妖精
function c90925163.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c90925163.condition)
	e1:SetOperation(c90925163.operation)
	c:RegisterEffect(e1)
end
function c90925163.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsDefensePos()
end
function c90925163.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_DEFENSE) then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
