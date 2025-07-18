--サイバーダーク・インパクト！
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,41230939,77625948,3019642,40418351)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		matfilter=s.matfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE }
		}
	})
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsCode(40418351)  --- 鎧黒竜－サイバー・ダーク・ドラゴン
end

function s.matfilter(c)
	--- material must be one of this name
	return c:IsFusionCode(41230939,77625948,3019642)
end
