--オッドアイズ・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsRace(RACE_DRAGON)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
		location=location|LOCATION_EXTRA
	end
	return location
end

function s.fusion_spell_matfilter(c)
	--- materials from extra must be オッドアイズ
	if c:IsLocation(LOCATION_EXTRA) and not c:IsFusionSetCard(0x99) then
		return false
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Can have at most 2 from extra deck
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_EXTRA) end,nil)>2 then
		return false
	end
	return true
end
