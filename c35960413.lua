--コウ・キューピット
---@param c Card
function c35960413.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35960413,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,35960413)
	e1:SetCondition(c35960413.spcon)
	e1:SetTarget(c35960413.sptg)
	e1:SetOperation(c35960413.spop)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35960413,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,35960414)
	e2:SetCost(c35960413.lvcost)
	e2:SetTarget(c35960413.lvtg)
	e2:SetOperation(c35960413.lvop)
	c:RegisterEffect(e2)
end
function c35960413.filter(c)
	return c:IsFaceup() and c:IsDefense(600)
end
function c35960413.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c35960413.filter,tp,LOCATION_MZONE,0,nil)
	return ct>0 and ct==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c35960413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35960413.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c35960413.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c35960413.lvfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingTarget(c35960413.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLevel())
end
function c35960413.cfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:IsLevel(lv)
end
function c35960413.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c35960413.lvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c35960413.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c35960413.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,tc:GetLevel())
end
function c35960413.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and lc:IsRelateToEffect(e) and lc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
