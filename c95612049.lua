--リバース・オブ・ザ・ワールド
function c95612049.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2Code2(c,46427957,72426662,LOCATION_HAND+LOCATION_DECK,nil,c95612049.mfilter)
	e1:SetCountLimit(1,95612049+EFFECT_COUNT_CODE_OATH)
end
function c95612049.mfilter(c)
	return not c:IsOnField() and c:IsType(TYPE_RITUAL)
end
