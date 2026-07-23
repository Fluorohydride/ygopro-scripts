--Thundercrash Snarecrow
local s,id,o=GetID()
function s.initial_effect(c)
	--destroy
	local code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(code)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return not c:IsRace(RACE_THUNDER) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(s.cfilter,nil)
	Duel.SetTargetCard(g)
end
function s.desfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(s.desfilter,nil,e)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(s.descon2)
		e1:SetOperation(s.desop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.desfilter2(c)
	return c:GetFlagEffect(id)~=0
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(s.desfilter2,1,nil)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.desfilter2,nil)
	Duel.Destroy(tg,REASON_EFFECT)
	g:DeleteGroup()
end
function s.tfilter(c)
	return c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.tfilter(chkc) and chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingTarget(s.tfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.Destroy(tc,REASON_EFFECT)~=0
		and c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
