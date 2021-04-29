--超融合
function c48130397.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE,
		get_extra_mat=c48130397.get_extra_mat,
	})
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c48130397.cost)
end
function c48130397.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c48130397.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c48130397.filter1,tp,0,LOCATION_MZONE,nil,e)
end
function c48130397.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
