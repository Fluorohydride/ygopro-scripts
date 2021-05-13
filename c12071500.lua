--ダーク・コーリング
function c12071500.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--Activate
	local e1=aux.AddFusionEffectProc(c,c12071500.filter,LOCATION_HAND+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove,{
		spsummon_nocheck=true
	})
end
function c12071500.filter(c)
	return c.dark_calling
end
