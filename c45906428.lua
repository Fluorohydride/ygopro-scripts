--ミラクル・フュージョン
function c45906428.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0x3008),LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove)
end
