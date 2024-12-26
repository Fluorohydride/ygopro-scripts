--鉄獣の血盟
---@param c Card
function c86379342.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86379342)
	e1:SetTarget(c86379342.sptg)
	e1:SetOperation(c86379342.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86379342,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,86379342)
	e2:SetCondition(c86379342.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c86379342.negtg)
	e2:SetOperation(c86379342.negop)
	c:RegisterEffect(e2)
end
function c86379342.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c86379342.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetRace())
end
function c86379342.spfilter2(c,e,tp,race)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and not c:IsRace(race) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86379342.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c86379342.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(c86379342.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c86379342.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c86379342.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c86379342.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetRace())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c86379342.cfilter(c,tp)
	return c:IsRace(RACE_BEAST) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c86379342.cfilter1,tp,LOCATION_MZONE,0,1,c,c,tp)
end
function c86379342.cfilter1(c,c1,tp)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c86379342.cfilter2,tp,LOCATION_MZONE,0,1,Group.FromCards(c,c1))
end
function c86379342.cfilter2(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsFaceup()
end
function c86379342.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c86379342.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c86379342.negfilter(c)
	return aux.NegateAnyFilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c86379342.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c86379342.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86379342.negfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c86379342.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c86379342.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end
