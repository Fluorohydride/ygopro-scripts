--リバース・オブ・ザ・ワールド
function c95612049.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c95612049.filter,LOCATION_HAND+LOCATION_DECK,nil,c95612049.mfilter)
	e1:SetCountLimit(1,95612049+EFFECT_COUNT_CODE_OATH)
end
function c95612049.mfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)
end
function c95612049.filter(c)
	return c:IsCode(72426662,46427957)
end
