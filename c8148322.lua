--プレデター・プライム・フュージョン
function c8148322.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),
		mat_location=LOCATION_MZONE,
		get_extra_mat=c8148322.get_extra_mat,
		fcheck=c8148322.fcheck
	})
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,8148322+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c8148322.condition)
end
function c8148322.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f3)
end
function c8148322.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8148322.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c8148322.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c8148322.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c8148322.filter1,tp,0,LOCATION_MZONE,nil,e)
end
function c8148322.ffilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c8148322.fcheck(tp,sg,fc)
	return sg:FilterCount(c8148322.ffilter,nil,tp)>=2
end
