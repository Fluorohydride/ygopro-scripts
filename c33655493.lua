--闇の侯爵ベリアル
function c33655493.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(c33655493.tg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33655493.tg)
	e2:SetValue(c33655493.tgval)
	c:RegisterEffect(e2)
end
function c33655493.tg(e,c)
	return c:IsFaceup() and c:GetCode()~=33655493
end
function c33655493.tgval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=e:GetHandlerPlayer()
end
