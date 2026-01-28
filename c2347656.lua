--白銀の城のラビュリンス
function c2347656.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c2347656.chainop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2347656,0))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,2347656)
	e2:SetTarget(c2347656.sttg)
	e2:SetOperation(c2347656.stop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2347656,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,2347657)
	e3:SetCondition(c2347656.descon)
	e3:SetTarget(c2347656.destg)
	e3:SetOperation(c2347656.desop)
	c:RegisterEffect(e3)
end
function c2347656.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and ep==tp then
		Duel.SetChainLimit(c2347656.chainlm)
	end
end
function c2347656.chainlm(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_MONSTER)
end
function c2347656.stfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c2347656.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c2347656.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2347656.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c2347656.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c2347656.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(2347656,2))
		e1:SetCondition(c2347656.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c2347656.actfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c2347656.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and not Duel.IsExistingMatchingCard(c2347656.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2347656.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c2347656.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and rp==tp and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetOriginalType()==TYPE_TRAP
		and eg:IsExists(c2347656.cfilter,1,nil)
end
function c2347656.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c2347656.desop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(2347656,3),aux.Stringid(2347656,4))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
