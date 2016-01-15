--アモルファージ・ライシス
function c47598941.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DESTROY)
	e1:SetTarget(c47598941.target1)
	e1:SetOperation(c47598941.operation)
	c:RegisterEffect(e1)
	--atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c47598941.atktg)
	e2:SetValue(c47598941.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47598941,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,47598941)
	e4:SetCondition(c47598941.condition)
	e4:SetCost(c47598941.cost)
	e4:SetTarget(c47598941.target2)
	e4:SetOperation(c47598941.operaton)
	e4:SetLabel(1)
	c:RegisterEffect(e4)
end
function c47598941.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	if Duel.GetFlagEffect(tp,47598941)==0 and res and teg:IsExists(c47598941.cfilter,1,nil,tp)
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c47598941.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,94) then
		Duel.RegisterFlagEffect(tp,47598941,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c47598941.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c47598941.val(e,c)
	return Duel.GetMatchingGroupCount(c47598941.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
function c47598941.atktg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0xe0)
end
function c47598941.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c47598941.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47598941.cfilter,1,nil,tp)
end
function c47598941.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(47598941)==0 end
	Duel.RegisterFlagEffect(47598941,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c47598941.setfilter(c)
	return c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47598941.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c47598941.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47598941.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47598941.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
