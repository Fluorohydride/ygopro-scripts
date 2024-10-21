--識無辺世壊
function c44553392.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c44553392.condition)
	e1:SetTarget(c44553392.target)
	e1:SetOperation(c44553392.activate)
	c:RegisterEffect(e1)
end
function c44553392.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,65815684)
end
function c44553392.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c44553392.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(56099748) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44553392.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=Duel.GetMatchingGroup(c44553392.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local ag=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,nil,65815684)
		if tc:IsOriginalCodeRule(65815684) and ft>0 and #sg>0
			and Duel.SelectYesNo(tp,aux.Stringid(44553392,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		elseif not tc:IsOriginalCodeRule(65815684) and #ag>0
			and Duel.SelectYesNo(tp,aux.Stringid(44553392,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local ag1=ag:Select(tp,1,1,nil)
			Duel.HintSelection(ag1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ag1:GetFirst():RegisterEffect(e1)
		end
	end
end
