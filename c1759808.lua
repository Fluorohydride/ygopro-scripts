--幻魔の肖像
function c1759808.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,1759808+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1759808.target)
	e1:SetOperation(c1759808.activate)
	c:RegisterEffect(e1)
end
function c1759808.cfilter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c1759808.cfilter2(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c1759808.cfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c1759808.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1759808.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ez=Duel.GetLocationCountFromEx(tp)
	local b1=Duel.IsExistingTarget(c1759808.cfilter1,tp,0,LOCATION_MZONE,1,nil,e,tp) and mz>0
	local b2=Duel.IsExistingTarget(c1759808.cfilter2,tp,0,LOCATION_MZONE,1,nil,e,tp) and ez>0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c1759808.cfilter(chkc,e,tp) end
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1759808.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local d1=Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode())
	local d2=Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetCode())
	if d1 and not d2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	if not d1 and d2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	if bit.band(tc:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM)==TYPE_PENDULUM then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	end
end
function c1759808.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ez=Duel.GetLocationCountFromEx(tp)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local d1=Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code)
		local d2=Duel.IsExistingMatchingCard(c1759808.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,code)
		if (bit.band(tc:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM)==TYPE_PENDULUM
			and ((d1 and mz>0) or (d2 and ez>0))) or (d1 and not d2 and mz>0) or (not d1 and d2 and ez>0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.GetMatchingGroup(c1759808.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,code)
			if mz<=0 then
				g=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			end
			if ez<=0 then
				g=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
			end
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:RegisterFlagEffect(1759808,RESET_EVENT+RESETS_STANDARD,0,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabel(Duel.GetTurnCount()+1)
				e1:SetLabelObject(sc)
				e1:SetCondition(c1759808.tdcon)
				e1:SetOperation(c1759808.tdop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c1759808.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1759808.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1759808)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c1759808.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c1759808.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA)
end
