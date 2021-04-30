--Myutant Fusion
function c42577802.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0x157),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_DECK,Card.IsAbleToRemove,aux.FMaterialRemove,{
		fcheck=c42577802.fcheck,
		gcheck=c42577802.gcheck
	})
	e1:SetCountLimit(1,42577802+EFFECT_COUNT_CODE_OATH)
	Duel.AddCustomActivityCounter(42577802,ACTIVITY_CHAIN,aux.FALSE)
end
function c42577802.fcheck(tp,sg,fc)
	local ct=0
	if Duel.GetCustomActivityCount(42577802,1-tp,ACTIVITY_CHAIN)~=0 then ct=1 end
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ct and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=ct
end
function c42577802.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
