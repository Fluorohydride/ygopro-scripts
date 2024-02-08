--ペンデュラム・アンコール
--not fully implemented
function c6992184.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,6992184+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c6992184.condition)
	e1:SetCost(c6992184.cost)
	e1:SetTarget(c6992184.target)
	e1:SetOperation(c6992184.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c6992184.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c6992184.check(e,tp,exc)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,exc,TYPE_PENDULUM)
	if #g==0 then return false end
	local pcon=aux.PendCondition()
	return pcon(e,lpz,g)
end
function c6992184.cfilter(c,e,tp)
	return c:IsDiscardable() and c6992184.check(e,tp,c)
end
function c6992184.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,TYPE_PENDULUM)
			or Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 then return false end
		return Duel.IsExistingMatchingCard(c6992184.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.DiscardHand(tp,c6992184.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
end
function c6992184.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return true
		end
		return c6992184.check(e,tp,nil)
	end
	e:SetLabel(0)
end
function c6992184.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetTargetRange(LOCATION_PZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(aux.indsval)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetOperation(c6992184.retop)
		Duel.RegisterEffect(e3,tp)
	end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_PENDULUM)
	if #g==0 then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	local pop=aux.PendOperation()
	pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
end
function c6992184.retop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
