--幽合－ゴースト・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		matfilter=s.matfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		mat_operation_code_map={
			{ [LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE]=FusionSpell.FUSION_OPERATION_BANISH },
			{ [0xff]=FusionSpell.FUSION_OPERATION_GRAVE }
		},
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.matfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_MZONE
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		location=location|LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE
	end
	return location
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- At most 1 materiao in deck+hand+grave
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE) end,nil)>1 then
		return false
	end
	return true
end
