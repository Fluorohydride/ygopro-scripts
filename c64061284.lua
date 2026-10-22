--古代の機械融合
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,83104731,95735217)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE,
		post_select_mat_location=LOCATION_DECK,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0x7)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- To use material from deck, must use 古代の機械巨人 or 古代の機械巨人－アルティメット・パウンド you control
	--- @param c Card
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_DECK) end,nil)>0 then
		--- @param c Card
		if not mg_all:IsExists(function(c) return c:IsOnField() and c:IsFusionCode(83104731,95735217) end,1,nil) then
			return false
		end
	end
	return true
end
