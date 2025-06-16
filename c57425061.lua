--幻影融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_SZONE,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		mat_operation_code_map={
			{ [LOCATION_SZONE]=FusionSpell.FUSION_OPERATION_BANISH },
			{ [0xff]=FusionSpell.FUSION_OPERATION_GRAVE }
		}
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0x8)
end

function s.fusion_spell_matfilter(c)
	if c:IsLocation(LOCATION_SZONE) and not c:IsAllTypes(TYPE_CONTINUOUS|TYPE_TRAP) then
		return false
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	local mg_szone=mg:Filter(function(c) return c:IsLocation(LOCATION_SZONE) end,nil)
	--- no more than 2
	if #mg_szone>2 then
		return false
	end
	return true
end
