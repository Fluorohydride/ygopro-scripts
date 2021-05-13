--魔玩具融合
function c6077601.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0xad),LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove)
	e1:SetCountLimit(1,6077601+EFFECT_COUNT_CODE_OATH)
end
