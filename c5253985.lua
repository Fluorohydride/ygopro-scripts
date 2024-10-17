--交差する魂
---@param c Card
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
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetRange(LOCATION_HAND)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		e1:SetOperation(c5253985.limitop)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(c5253985.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c5253985.cfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function c5253985.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local g=tc:GetMaterial()
	if g and g:IsExists(c5253985.cfilter,1,nil,tp) then
		Duel.AddCustomActivityCounter(5253985,ACTIVITY_CHAIN,c5253985.chainfilter)
		--activate limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(1,0)
		e3:SetCondition(c5253985.actcon)
		e3:SetValue(c5253985.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
	e:Reset()
end
function c5253985.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
function c5253985.chainfilter(re,tp,cid)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DIVINE)
end
function c5253985.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(5253985,tp,ACTIVITY_CHAIN)~=0
end
function c5253985.aclimit(e,re,tp)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DIVINE))
end
