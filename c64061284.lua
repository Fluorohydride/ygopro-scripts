--古代の機械融合
function c64061284.initial_effect(c)
	aux.AddCodeList(c,83104731)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x7),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,
		fcheck=c64061284.fcheck
	})
end
function c64061284.fcheck(tp,sg,fc)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		return sg:IsExists(c64061284.filterchk,1,nil) end
	return true
end
function c64061284.filterchk(c)
	return c:IsCode(83104731,95735217) and c:IsOnField()
end
