--プロモーション
function c88617904.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,88617904+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88617904.target)
	e1:SetOperation(c88617904.operation)
	c:RegisterEffect(e1)
end
function c88617904.tgfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(3)
		and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function c88617904.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88617904.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88617904.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c88617904.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c88617904.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c88617904.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88617904.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local g=Duel.GetMatchingGroup(c88617904.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			if Duel.IsExistingMatchingCard(c88617904.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
				Duel.BreakEffect()
				local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)*100
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(ct)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
			end
		end
	end
end
function c88617904.atkfilter(c)
	return c:GetOriginalRace()==RACE_WARRIOR and c:GetOriginalAttribute()==ATTRIBUTE_EARTH and c:IsSetCard(0x83) and c:IsFaceup()
end
