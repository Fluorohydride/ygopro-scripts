--リヴェンデット・ボーン
function c94666032.initial_effect(c)
	aux.AddRitualProcGreater2(c,c94666032.filter,LOCATION_HAND+LOCATION_GRAVE,c94666032.mfilter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c94666032.reptg)
	e2:SetValue(c94666032.repval)
	e2:SetOperation(c94666032.repop)
	c:RegisterEffect(e2)
end
c94666032.card_code_list={4388680}
function c94666032.filter(c)
	return c:IsSetCard(0x106)
end
function c94666032.mfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c94666032.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(4388680)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c94666032.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c94666032.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c94666032.repval(e,c)
	return c94666032.repfilter(c,e:GetHandlerPlayer())
end
function c94666032.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
