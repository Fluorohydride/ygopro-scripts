--超電導波サンダーフォース
function c42469671.initial_effect(c)
	aux.AddCodeList(c,10000020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,42469671+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c42469671.descon)
	e1:SetTarget(c42469671.destg)
	e1:SetOperation(c42469671.desop)
	c:RegisterEffect(e1)
end
function c42469671.actfilter(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(10000020)
end
function c42469671.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c42469671.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c42469671.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	end
end
function c42469671.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c42469671.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup():FilterCount(c42469671.sgfilter,nil,1-tp)
	if dc~=0 and Duel.IsTurnPlayer(tp) and Duel.IsMainPhase() and Duel.IsPlayerCanDraw(tp,dc)
		and Duel.SelectYesNo(tp,aux.Stringid(42469671,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,dc,REASON_EFFECT)
		--cannot attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(c42469671.atkcon)
		e1:SetTarget(c42469671.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--check
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c42469671.checkop)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function c42469671.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,42469671)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,42469671,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c42469671.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),42469671)~=0
end
function c42469671.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
