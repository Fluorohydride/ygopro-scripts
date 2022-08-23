--宣告者の神託
function c79306385.initial_effect(c)
	--Activate
	aux.AddRitualProcGreaterCode(c,48546368,nil,nil,nil,false,nil,c79306385.extratg)
end
function c79306385.extratg(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c79306385.chlimit)
	end
end
function c79306385.chlimit(e,ep,tp)
	return tp==ep
end
