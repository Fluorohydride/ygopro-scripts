--ダーク・コーリング
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--Activate
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		extra_target=s.extra_target,
		sumtype=SUMMON_VALUE_DARK_FUSION
	})
end

function s.fusfilter(c)
	return c.dark_calling==true
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
