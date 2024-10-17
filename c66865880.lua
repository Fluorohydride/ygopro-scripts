--マシュマロンのメガネ
---@param c Card
function c66865880.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c66865880.con)
	e2:SetValue(c66865880.atlimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c66865880.con)
	c:RegisterEffect(e3)
end
function c66865880.cfilter(c)
	return c:IsFaceup() and c:IsCode(31305911)
end
function c66865880.con(e)
	return Duel.IsExistingMatchingCard(c66865880.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c66865880.atlimit(e,c)
	return c:IsFacedown() or not c:IsCode(31305911)
end
