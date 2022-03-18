--インフェルニティ・ビースト
function c7264861.initial_effect(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c7264861.aclimit)
	e1:SetCondition(c7264861.condition)
	c:RegisterEffect(e1)
end
function c7264861.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and tc and tc==e:GetHandler() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
end
function c7264861.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
