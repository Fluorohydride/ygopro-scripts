--古代の機械兵士
function c56094445.initial_effect(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c56094445.aclimit)
	e1:SetCondition(c56094445.actcon)
	c:RegisterEffect(e1)
end
function c56094445.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c56094445.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
