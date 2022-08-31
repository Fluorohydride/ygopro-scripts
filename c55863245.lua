--たつのこ
function c55863245.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c55863245.efilter)
	c:RegisterEffect(e2)
	--extra hand link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetValue(c55863245.matval)
	e3:SetCondition(c55863245.syncon)
	c:RegisterEffect(e3)
end
function c55863245.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c55863245.matval(e,sync,mg,c,tp)
	return true,not mg or mg:IsContains(e:GetHandler()) and not mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
end
function c55863245.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
