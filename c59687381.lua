--ディフェンスゾーン
function c59687381.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot be target/indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c59687381.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c59687381.tgvalue)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetValue(c59687381.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c59687381.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c59687381.tgtg(e,c)
	return c:GetSequence()<5 and c:GetColumnGroup():FilterCount(c59687381.tgfilter,nil,c:GetControler())>0
end
function c59687381.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c59687381.tgoval(e,re,rp)
	return rp~=1-e:GetHandlerPlayer()
end
