--オーバーロード・フュージョン
function c3659803.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,c3659803.filter,LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove)
end
function c3659803.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_MACHINE)
end
