--聖なる法典
function c34933456.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		get_extra_mat=c34933456.get_extra_mat,
		fcheck=c34933456.fcheck
	})
	e1:SetCountLimit(1,34933456+EFFECT_COUNT_CODE_OATH)
end
function c34933456.filter(c,e)
	local tc=c:GetEquipTarget()
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
		and tc and tc:IsSetCard(0x150)
end
function c34933456.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c34933456.filter,tp,LOCATION_SZONE,0,nil,e)
end
function c34933456.exfilter(c)
	return c:IsLocation(LOCATION_SZONE)
end
function c34933456.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsRace,nil,1,RACE_SPELLCASTER)
		and fc:IsSetCard(0x150) or not sg:IsExists(c34933456.exfilter,nil,1)
end
