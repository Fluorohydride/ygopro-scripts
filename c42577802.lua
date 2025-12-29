--フュージョン・ミュートリアス
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
end

function s.fusfilter(c)
	return c:IsSetCard(0x157)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)~=0 then
		location=location|LOCATION_DECK|LOCATION_GRAVE
	end
	return location
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- At most include 1 monster from Deck
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_DECK) end,nil)>1 then
		return false
	end
	--- At most include 1 monster from Grave
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_GRAVE) end,nil)>1 then
		return false
	end
	return true
end
