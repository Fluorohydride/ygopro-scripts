--白の烙印
function c34995106.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,
		fcheck=c34995106.fcheck
	})
	e1:SetDescription(aux.Stringid(34995106,0))
	e1:SetCountLimit(1,34995106)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34995106.regcon)
	e2:SetOperation(c34995106.regop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34995106,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,34995107)
	e3:SetCondition(c34995106.setcon)
	e3:SetTarget(c34995106.settg)
	e3:SetOperation(c34995106.setop)
	c:RegisterEffect(e3)
end
function c34995106.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsCode(68468459)
end
function c34995106.exfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c34995106.fcheck(tp,sg,fc)
	if sg:IsExists(c34995106.chkfilter,1,nil,tp) then
		return sg:IsExists(Card.IsRace,1,nil,RACE_DRAGON)
	else
		return sg:IsExists(Card.IsRace,1,nil,RACE_DRAGON) and not sg:IsExists(c34995106.exfilter,1,nil,tp)
	end
end
function c34995106.regcon(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return e:GetHandler():IsReason(REASON_COST) and re and re:IsActivated() and (code1==68468459 or code2==68468459)
end
function c34995106.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(34995106,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c34995106.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(34995106)>0
end
function c34995106.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c34995106.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
