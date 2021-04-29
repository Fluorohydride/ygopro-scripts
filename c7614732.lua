--Greater Polymerization
function c7614732.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		fgoalcheck=c7614732.fcheck,
		foperation=c7614732.fop
	})
end
function c7614732.fcheck(tp,sg,fc)
	return sg:GetCount()>=3
end
function c7614732.fop(e,tp,tc)
	--cannot be destroyed
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	--pierce
	local e2=Effect.CreateEffect(tc)
	e2:SetDescription(aux.Stringid(7614732,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	if not tc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
	end
end
