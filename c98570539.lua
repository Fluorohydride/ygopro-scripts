--混沌の夢魔鏡
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,74665651,1050355)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		extra_target=s.extra_target
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0x131)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_MZONE
	--- if 聖光の夢魔鏡 in FZONE, add hand
	if Duel.IsExistingMatchingCard(function(c) return c:IsCode(74665651) and c:IsFaceup() end,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then
		location=location|LOCATION_HAND
	end
	--- if 闇黒の夢魔鏡 in FZONE, add grave
	if Duel.IsExistingMatchingCard(function(c) return c:IsCode(1050355) and c:IsFaceup() end,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then
		location=location|LOCATION_GRAVE
	end
	return location
end
