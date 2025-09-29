--絵札融合
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.IsExistingMatchingCard(function(c) return c:IsCode(25652259,64788463,90876561) and c:IsFaceup() end,tp,LOCATION_ONFIELD,0,1,nil) then
		location=location|LOCATION_DECK
	end
	return location
end

function s.fusfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Can only use 1 monster from deck
	if mg:FilterCount(function(c) return c:IsLocation(LOCATION_DECK) end,nil)>1 then
		return false
	end
	return true
end
