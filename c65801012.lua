--サイバネット・フュージョン
function c65801012.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,
		grave_filter=c65801012.exfilter,
		fcheck=c65801012.fcheck,
		gcheck=c65801012.gcheck
	})
end
function c65801012.cfilter(c)
	return c:GetSequence()>=5
end
function c65801012.exfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c65801012.fcheck(tp,sg,fc)
	local ct=0
	if not Duel.IsExistingMatchingCard(c65801012.cfilter,tp,LOCATION_MZONE,0,1,nil) then ct=1 end
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=ct
end
function c65801012.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
