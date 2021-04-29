--D－フュージョン
function c26841274.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE,
		mat_filter=aux.FilterBoolFunction(Card.IsSetCard,0xc008),
		foperation=c26841274.fop
	})
end
function c26841274.fop(e,tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e2)
end
