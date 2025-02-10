--Beast of Talwar - The Sword Summit
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.hspcon)
	c:RegisterEffect(e1)
	--indestructible
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.indct)
	--cannot target
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0x34,0x34)
	e3:SetTarget(s.tglimit)
	e3:SetValue(s.tgoval)
	c:RegisterEffect(e3)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.indct(e,re,r,rp)
	if r&REASON_EFFECT>0 and e:GetOwnerPlayer()~=rp then
		return 1
	else return 0 end
end
function s.tglimit(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function s.tgoval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_EQUIP)
end
