--誓いのエンブレーマ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsSetCard(0x1a2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) and ct>0
	end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		--splimit
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,0)
		e0:SetLabel(tc:GetOriginalCodeRule())
		e0:SetCondition(s.splimitcon)
		e0:SetTarget(s.splimit)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
	end
end
function s.filter2(c,e)
	return c:IsOriginalCodeRule(e:GetLabel()) and c:IsFaceup()
end
function s.splimitcon(e)
	return Duel.IsExistingMatchingCard(s.filter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,e)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x1a2) and c:IsLocation(LOCATION_EXTRA)
end
function s.setfilter(c,ct)
	return c:IsSetCard(0x1a2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (ct>0 or c:IsType(TYPE_FIELD))
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,ct) end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,ct)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
