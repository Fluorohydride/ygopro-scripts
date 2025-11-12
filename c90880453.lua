--エルフェンノーツ～再邂のテルチェット～
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.piercecon)
	e3:SetTarget(s.piercetg)
	c:RegisterEffect(e3)
	--cannot be destroyed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(s.indcon)
	e4:SetTarget(s.indtg)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--avoid battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(s.abdcon)
	c:RegisterEffect(e5)
end
function s.tglimit(e,c)
	return c:GetSequence()==2
end
function s.piercefilter(c)
	return c:GetSequence()==2 and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE)
		and c:IsFaceup()
end
function s.piercecon(e)
	return Duel.IsExistingMatchingCard(s.piercefilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.piercetg(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function s.indfilter(c)
	return c:GetSequence()==2 and c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND)
		and c:IsFaceup()
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.indtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.abdfilter(c)
	return c:GetSequence()==2 and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and c:IsFaceup()
end
function s.abdcon(e)
	return Duel.IsExistingMatchingCard(s.abdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
