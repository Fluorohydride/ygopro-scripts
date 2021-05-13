--転臨の守護竜
function c40003819.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,nil,LOCATION_MZONE+LOCATION_GRAVE,c40003819.filter,aux.FMaterialRemove)
	e1:SetCountLimit(1,40003819+EFFECT_COUNT_CODE_OATH)
end
function c40003819.filter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemove()
end
