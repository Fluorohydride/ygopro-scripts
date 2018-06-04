--方界曼荼羅
function c8837932.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCondition(c8837932.condition)
	e1:SetTarget(c8837932.target)
	e1:SetOperation(c8837932.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c8837932.disop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c8837932.descon)
	e3:SetOperation(c8837932.desop)
	c:RegisterEffect(e3)
end
function c8837932.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3)
end
function c8837932.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8837932.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c8837932.spfilter(c,e,tp,tid)
	return c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER) and c:GetTurnID()==tid
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c8837932.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c8837932.spfilter(chkc,e,tp,tid) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c8837932.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.SelectTarget(tp,c8837932.spfilter,tp,0,LOCATION_GRAVE,1,ft,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c8837932.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local sc=sg:GetFirst()
	while sc do
		if Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP) then
			c:SetCardTarget(sc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	local oc=og:GetFirst()
	while oc do
		oc:AddCounter(0x1038,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetCondition(c8837932.disable)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_DISABLE)
		oc:RegisterEffect(e3)
		oc=og:GetNext()
	end
end
function c8837932.disable(e)
	return e:GetHandler():GetCounter(0x1038)>0
end
function c8837932.dfilter(c,g)
	return g:IsContains(c)
end
function c8837932.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	if re:IsActiveType(TYPE_MONSTER) and rp==1-tp
		and Duel.IsExistingMatchingCard(c8837932.dfilter,tp,0,LOCATION_MZONE,1,nil,g) then
		Duel.NegateEffect(ev)
	end
end
function c8837932.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return eg:FilterCount(c8837932.dfilter,nil,g)>0
		and not Duel.IsExistingMatchingCard(c8837932.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,g)
end
function c8837932.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
