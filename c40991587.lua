--ワイト夫人
function c40991587.initial_effect(c)
	aux.AddCodeList(c,32274490)
	--change code
	aux.EnableChangeCode(c,32274490,LOCATION_GRAVE)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c40991587.etarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c40991587.etarget)
	e3:SetValue(c40991587.efilter)
	c:RegisterEffect(e3)
end
function c40991587.etarget(e,c)
	return c:GetCode()~=40991587 and c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(3)
end
function c40991587.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not te:GetHandler():IsCode(4064256)
end
