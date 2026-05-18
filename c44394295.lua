--影依融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0x9d)
end

---@type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local res=LOCATION_HAND|LOCATION_MZONE
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		res=res|LOCATION_DECK
	end
	return res
end

function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end

