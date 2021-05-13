--神の写し身との接触
function c6417578.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0x9d))
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,6417578+EFFECT_COUNT_CODE_OATH)
end
