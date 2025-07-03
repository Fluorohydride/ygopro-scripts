--Aiラブ融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		post_select_mat_opponent_location=LOCATION_MZONE,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

---@param c Card
function s.fusfilter(c)
	return c:IsRace(RACE_CYBERSE)
end

function s.fusion_spell_matfilter(c,e,tp)
	--- if it comes from opponent, it must be a link monster
	if c:IsControler(1-tp) and not c:IsType(TYPE_LINK) then
		return false
	end
	return true
end

---@type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	-- Filter the group to get only the opponent’s Fusion Materials
	---@param c Card
	local mg_opponent=mg:Filter(function(c) return c:IsControler(1-tp) end,nil)
	-- No more than one Fusion Material from the opponent is allowed
	if #mg_opponent>1 then
		return false
	end
	-- If using an opponent’s monster, you must also use at least one ＠イグニスター monster belongs to you
	---@param c Card
	if #mg_opponent>0 and not mg_all:IsExists(function(c)
				return c:IsControler(tp) and c:IsFusionSetCard(0x135)
			end,1,nil) then
		return false
	end
	return true
end
