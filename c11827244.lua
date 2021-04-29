--円融魔術
function c11827244.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove)
	e1:SetCountLimit(1,11827244+EFFECT_COUNT_CODE_OATH)
end
