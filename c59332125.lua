--Aiラブ融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_opponent_location=LOCATION_MZONE,
		additional_fcheck=s.fcheck
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

---@param c Card
function s.fusfilter(c)
	return c:IsRace(RACE_CYBERSE)
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
	-- Any opponent material used must be a LINK monster
	---@param c Card
	if mg_opponent:IsExists(function(c) return not c:IsType(TYPE_LINK) end,1,nil) then
		return false
	end
	-- If using an opponent’s monster, you must also use at least one “@Ignister” monster you control
	---@param c Card
	if #mg_opponent>0 and not mg_all:IsExists(function(c)
				return c:IsControler(tp) and c:IsFusionSetCard(0x135)
			end,1,nil) then
		return false
	end
	return true
end
