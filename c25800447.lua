--フュージョン・オブ・ファイア
function c25800447.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x119),
		get_extra_mat=c25800447.get_extra_mat
	})
	e1:SetCountLimit(1,25800447+EFFECT_COUNT_CODE_OATH)
end
function c25800447.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c25800447.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c25800447.filter1,tp,0,LOCATION_MZONE,nil,e)
end
