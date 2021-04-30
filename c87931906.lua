--月光融合
function c87931906.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0xdf),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,
		fcheck=c87931906.fcheck,
		get_gcheck=c87931906.get_gcheck
	})
	e1:SetCountLimit(1,87931906+EFFECT_COUNT_CODE_OATH)
end
function c87931906.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c87931906.fcheck(tp,sg,fc)
	local ct=0
	if Duel.IsExistingMatchingCard(c87931906.cfilter,tp,0,LOCATION_MZONE,1,nil) then ct=1 end
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=ct
end
function c87931906.get_gcheck(e,tp,fc)
	return function(sg)
		local ct=0
		if Duel.IsExistingMatchingCard(c87931906.cfilter,tp,0,LOCATION_MZONE,1,nil) then ct=1 end
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=ct
	end
end
