--氷結界の御庭番
function c27527047.initial_effect(c)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2f))
	e1:SetValue(c27527047.tgval)
	c:RegisterEffect(e1)
end
function c27527047.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
