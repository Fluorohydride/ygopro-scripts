--影依融合
function c44394295.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x9d),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,
		fcheck=c44394295.fcheck,
		get_gcheck=c44394295.get_gcheck
	})
	e1:SetCountLimit(1,44394295+EFFECT_COUNT_CODE_OATH)
end
function c44394295.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c44394295.fcheck(tp,sg,fc)
	if Duel.IsExistingMatchingCard(c44394295.cfilter,tp,0,LOCATION_MZONE,1,nil) then return true end
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=0
end
function c44394295.get_gcheck(e,tp,fc)
	return function(sg)
		if Duel.IsExistingMatchingCard(c44394295.cfilter,tp,0,LOCATION_MZONE,1,nil) then return true end
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=0
	end
end
