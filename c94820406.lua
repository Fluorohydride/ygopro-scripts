--ダーク・フュージョン
function c94820406.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),
		foperation=c94820406.fop
	})
end
function c94820406.fop(e,tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(aux.tgoval)
	tc:RegisterEffect(e1)
end
