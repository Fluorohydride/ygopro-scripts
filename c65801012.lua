--サイバネット・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsRace(RACE_CYBERSE)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if not Duel.IsExistingMatchingCard(function(c) return c:GetSequence()>=5 end,tp,LOCATION_MZONE,0,1,nil) then
		location=location|LOCATION_GRAVE
	end
	return location
end

function s.fusion_spell_matfilter(c)
	--- material from Grave must be サイバース族 Link monster
	if c:IsLocation(LOCATION_GRAVE) and not (c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)) then
		return false
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- At most 1 monster from Grave
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_GRAVE) end,nil)>1 then
		return false
	end
	return true
end
