--月光融合
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		additional_fcheck=s.fcheck,
		additional_gcheck=s.gcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

---@param c Card
function s.fusfilter(c)
	return c:IsSetCard(0xdf)
end

---@type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local res=LOCATION_HAND|LOCATION_MZONE
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		res=res|LOCATION_DECK|LOCATION_EXTRA
	end
	return res
end

function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end

function s.fcheck(tp,mg,fc,all_mg)
	---@type Group
	local extra_mg=mg:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if #extra_mg==0	then
		return true
	end
	--- by fusion spell, the material from deck/extra can only be at most 1
	if #extra_mg>1 then
		return false
	end
	--- by fusion spell, the material from deck/extra must be Lunalight monster
	if extra_mg:FilterCount(Card.IsSetCard,nil,0xdf)~=#extra_mg then
		return false
	end
	return true
end
function s.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1
end
