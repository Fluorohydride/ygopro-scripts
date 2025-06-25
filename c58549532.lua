--混錬装融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_EXTRA,
		additional_fcheck=s.fcheck,
		fusion_spell_matfilter=s.fusion_spell_matfilter
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0xe1)
end

--- @param c Card
function s.fusion_spell_matfilter(c)
	if c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_PENDULUM) and c:IsFaceup()) then
		return false
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Can only have 1 monster from hand
	if mg_all:FilterCount(function(c) return c:IsLocation(LOCATION_HAND) end,nil)>1 then
		return false
	end
	--- Can only have 1 monster from field
	if mg_all:FilterCount(function(c) return c:IsOnField() end,nil)>1 then
		return false
	end
	--- Can only have 1 monster from extra
	if mg_all:FilterCount(function(c) return c:IsLocation(LOCATION_EXTRA) end,nil)>1 then
		return false
	end
	return true
end
