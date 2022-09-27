--転生炎獣の炎虞
function c28534130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28534130+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28534130.target)
	e1:SetOperation(c28534130.activate)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28534130,0))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28534130.tdtg)
	e2:SetOperation(c28534130.tdop)
	c:RegisterEffect(e2)
end
function c28534130.lkfilter(c,mc)
	return c:IsSetCard(0x119) and c:IsLinkSummonable(nil,mc)
end
function c28534130.spfilter(c,e,tp)
	return c:IsSetCard(0x119) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c28534130.lkfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c28534130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c28534130.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c28534130.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c28534130.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	tc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	if not tc:IsLocation(LOCATION_MZONE) then return end
	local tg=Duel.GetMatchingGroup(c28534130.lkfilter,tp,LOCATION_EXTRA,0,nil,tc)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e3:SetOperation(c28534130.regop)
		sc:RegisterEffect(e3)
		Duel.LinkSummon(tp,sc,nil,tc)
	end
end
function c28534130.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetOwner()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2,true)
	e:Reset()
end
function c28534130.tdfilter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function c28534130.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c28534130.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28534130.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28534130.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c28534130.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
