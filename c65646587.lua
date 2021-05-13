--ペンデュラム・フュージョン
function c65646587.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE+LOCATION_PZONE,
		fcheck=c65646587.fcheck
	})
	e1:SetCountLimit(1,65646587+EFFECT_COUNT_CODE_OATH)
end
function c65646587.fcheck(tp,sg,fc)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 or sg:FilterCount(Card.IsLocation,nil,LOCATION_PZONE)==0
end
