--聖なる法典
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		pre_select_mat_location=s.pre_select_mat_location,
		additional_fcheck=s.fcheck
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

---@type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	---  If Summoning a "Magistus" Fusion Monster, you can also use monsters in your Spell & Trap Zones
	if tc:IsSetCard(0x150) then
		location=location|LOCATION_SZONE
	end
	return location
end

---@type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,tc,mg_all)
	--- materials must include a Spellcaster monster
	--- @param c Card
	if not mg_all:IsExists(function(c) return c:IsRace(RACE_SPELLCASTER) end,1,nil) then
		return false
	end
	--- when we have mg in SZONE, we already know tc is Magistus
	--- you can only use monsters in your Spell & Trap Zones that are equipped to a "Magistus" monster.
	local mg_szone=mg:Filter(function(c) return c:IsLocation(LOCATION_SZONE) end,nil)
	if mg_szone:IsExists(aux.NOT(s.mttg),1,nil) then
		return false
	end
	return true
end

function s.mttg(c)
	local tc=c:GetEquipTarget()
	return tc and tc:IsSetCard(0x150) and c:GetOriginalType()&TYPE_MONSTER~=0
end
