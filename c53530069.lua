--そよ風の精霊
function c53530069.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c53530069.condition)
	e1:SetOperation(c53530069.operation)
	c:RegisterEffect(e1)
end
function c53530069.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsAttackPos()
end
function c53530069.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,53530069)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
