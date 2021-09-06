--エクソシスター・バディス
function c77891946.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,77891946+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c77891946.cost)
	e1:SetTarget(c77891946.target)
	e1:SetOperation(c77891946.activate)
	c:RegisterEffect(e1)
end
function c77891946.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c77891946.spfilter1(c,e,tp)
	return c:IsSetCard(0x172) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77891946.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp,c)
end
function c77891946.spfilter2(c,e,tp,ec)
	return c:IsSetCard(0x172) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.IsCodeListed(ec,c:GetCode())
end
function c77891946.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c77891946.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_DECK)
end
function c77891946.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77891946.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g1==0 then return end
	local g2=Duel.SelectMatchingCard(tp,c77891946.spfilter2,tp,LOCATION_DECK,0,1,1,g1,e,tp,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(77891946,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c77891946.tdcon)
		e1:SetOperation(c77891946.tdop)
		Duel.RegisterEffect(e1,tp)
		tc=g1:GetNext()
	end
	Duel.SpecialSummonComplete()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77891946.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77891946.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(77891946)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c77891946.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c77891946.splimit(e,c)
	return not c:IsSetCard(0x172) and c:IsLocation(LOCATION_EXTRA)
end
