--機械天使の儀式
function c39996157.initial_effect(c)
	aux.AddRitualProcGreater2(c,c39996157.ritual_filter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c39996157.reptg)
	e2:SetValue(c39996157.repval)
	e2:SetOperation(c39996157.repop)
	c:RegisterEffect(e2)
end
function c39996157.ritual_filter(c)
	return c:IsSetCard(0x2093)
end
function c39996157.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c39996157.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c39996157.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c39996157.repval(e,c)
	return c39996157.repfilter(c,e:GetHandlerPlayer())
end
function c39996157.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
