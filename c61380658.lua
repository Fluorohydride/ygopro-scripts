--エレキリギリス
function c61380658.initial_effect(c)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c61380658.atlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c61380658.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c61380658.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xe) and c~=e:GetHandler()
end
function c61380658.tglimit(e,c)
	return c:IsSetCard(0xe) and c~=e:GetHandler()
end
