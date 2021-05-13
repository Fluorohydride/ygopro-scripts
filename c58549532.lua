--パラメタルフォーズフュージョン
function c58549532.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0xe1),
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,
		extra_filter=c58549532.filter,
		fcheck=c58549532.fcheck,
		gcheck=c58549532.gcheck
	})
	e1:SetCountLimit(1,58549532+EFFECT_COUNT_CODE_OATH)
end
function c58549532.filter(c)
	return c:IsCanBeFusionMaterial() and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c58549532.fcheck(tp,sg,fc)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c58549532.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
