--交差する魂
function c5253985.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5253985,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,5253985+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c5253985.sumcon)
	e1:SetTarget(c5253985.sumtg)
	e1:SetOperation(c5253985.sumop)
	c:RegisterEffect(e1)
end
function c5253985.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c5253985.sumfilter(c,ec)
	if not c:IsRace(RACE_DIVINE) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil,1)
	e1:Reset()
	return res
end
function c5253985.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5253985.sumfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c5253985.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c5253985.sumfilter,tp,LOCATION_HAND,0,1,1,nil,c):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetRange(LOCATION_HAND)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--can't activate effects
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c5253985.regop)
		tc:RegisterEffect(e2,true)
		--reset when negated
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_NEGATED)
		e3:SetOperation(c5253985.rstop)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3,tp)
		e2:SetLabelObject(e3)
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c5253985.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	if g and g:IsExists(c5253985.cfilter,1,nil,tp) then
		local oc=e:GetOwner()
		local e1=Effect.CreateEffect(oc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c5253985.regcon2)
		e1:SetOperation(c5253985.regop2)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(oc)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c5253985.actcon)
		e2:SetValue(c5253985.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
	local e3=e:GetLabelObject()
	e3:Reset()
	e:Reset()
end
function c5253985.cfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function c5253985.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not re:GetHandler():IsRace(RACE_DIVINE)
end
function c5253985.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,5253985,RESET_PHASE+PHASE_END,2,0,1)
end
function c5253985.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,5253985)>0
end
function c5253985.aclimit(e,re,tp)
	return not re:GetHandler():IsRace(RACE_DIVINE)
end
function c5253985.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
