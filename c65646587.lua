--ペンデュラム・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		pre_select_mat_location=s.pre_select_mat_location
	})
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_MZONE
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 then
		location=location|LOCATION_PZONE
	end
	return location
end
