--覇王龍の魂
function c92428405.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92428405,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c92428405.cost)
	e1:SetTarget(c92428405.target)
	e1:SetOperation(c92428405.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92428405,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c92428405.spcon)
	e2:SetCost(c92428405.spcost)
	e2:SetTarget(c92428405.sptg)
	e2:SetOperation(c92428405.spop)
	c:RegisterEffect(e2)
end
function c92428405.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c92428405.filter(c,e,tp)
	return c:IsCode(13331639) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c92428405.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92428405.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c92428405.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92428405.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		tc:RegisterFlagEffect(92428405,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetLabelObject(tc)
		e3:SetCondition(c92428405.tdcon)
		e3:SetOperation(c92428405.tdop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.SpecialSummonComplete()
end
function c92428405.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(92428405)~=0
end
function c92428405.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,92428405)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c92428405.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL)
end
function c92428405.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(13331639) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c92428405.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c92428405.spfilter(c,e,tp,tc)
	if not (c:IsSetCard(0x10f2,0x2073,0x2017,0x1046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
	else
		return Duel.GetMZoneCount(tp,tc)>0
	end
end
function c92428405.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c92428405.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c92428405.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c92428405.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return true
		end
		return Duel.IsExistingMatchingCard(c92428405.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function c92428405.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c92428405.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function c92428405.gcheck(g,ft1,ft2,ft3,ect,ft)
	return #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)<=ft1
		and g:FilterCount(c92428405.exfilter2,nil)<=ft2
		and g:FilterCount(c92428405.exfilter3,nil)<=ft3
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
		and g:FilterCount(Card.IsSetCard,nil,0x10f2)<=1
		and g:FilterCount(Card.IsSetCard,nil,0x2073)<=1
		and g:FilterCount(Card.IsSetCard,nil,0x2017)<=1
		and g:FilterCount(Card.IsSetCard,nil,0x1046)<=1
end
function c92428405.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ect>0 and (ft2>0 or ft3>0) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c92428405.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=sg:SelectSubGroup(tp,c92428405.gcheck,false,1,4,ft1,ft2,ft3,ect,ft)
	Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
end
