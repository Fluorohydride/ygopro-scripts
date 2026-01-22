--ヴァレット・コーダー
--not fully implemented
local s,id,o=GetID()
function s.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.matval1)
	c:RegisterEffect(e1)
	--link race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--extra hand link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e3:SetCountLimit(1,id+o)
	e3:SetValue(s.matval2)
	c:RegisterEffect(e3)
end
function s.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE) and c:IsControler(tp)
end
function s.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(id)
end
function s.matval1(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x101) then return false,nil end
	return true,not mg or mg:IsExists(s.mfilter,1,nil,tp) and not mg:IsExists(s.exmfilter,1,nil)
end
function s.exmatcheck(c,lc,tp)
	if not c:IsLocation(LOCATION_HAND) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(id) then return false end
	end
	return true
end
function s.matval2(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x10f) then return false,nil end
	return true,not mg or mg:IsContains(e:GetHandler()) and not mg:IsExists(s.exmatcheck,1,nil,lc,tp)
end
