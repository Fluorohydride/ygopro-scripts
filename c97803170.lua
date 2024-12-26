--デーモンの呼び声
---@param c Card
function c97803170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c97803170.target)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97803170,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c97803170.cost)
	e2:SetTarget(c97803170.sptg)
	e2:SetOperation(c97803170.spop)
	c:RegisterEffect(e2)
end
function c97803170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,97803170)==0 end
	Duel.RegisterFlagEffect(tp,97803170,RESET_PHASE+PHASE_END,0,1)
end
function c97803170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c97803170.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c97803170.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c97803170.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	if b1 and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c97803170.spop)
		c97803170.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c97803170.sptg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c97803170.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97803170.cfilter(c)
	return c:IsRace(RACE_FIEND)
end
function c97803170.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97803170.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c97803170.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c97803170.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c97803170.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c97803170.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,c97803170.cfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
