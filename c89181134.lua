--捕食植物サンデウ・キンジー
local s,id,o=GetID()
function s.initial_effect(c)
	--fusattribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_FUSION_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.attrtg)
	e1:SetValue(s.attrval)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_opponent_location=LOCATION_MZONE,
		additional_fcheck=s.fcheck,
		gc=s.gc
	})
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end

function s.attrtg(e,c)
	return c:GetCounter(0x1041)>0
end

function s.attrval(e,c,rp)
	if rp==e:GetHandlerPlayer() then
		return ATTRIBUTE_DARK
	else return c:GetAttribute() end
end

function s.fusfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,tc,mg_all)
	--- can only use monsters with a Predator Counter your opponent controls
	local mg_opponent=mg:Filter(function(c) return c:IsControler(1-tp) end,nil)
	--- @param c Card
	if mg_opponent:IsExists(function(c) return c:GetCounter(0x1041)<1 end,1,nil) then
		return false
	end
	return true
end

function s.gc(e)
	return e:GetHandler()
end
