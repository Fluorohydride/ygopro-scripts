--マジスタリー・アルケミスト
function c58270977.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,58270977+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c58270977.cost)
	e1:SetTarget(c58270977.target)
	e1:SetOperation(c58270977.activate)
	c:RegisterEffect(e1)
end
function c58270977.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c58270977.spfilter(c,e,tp)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c58270977.fselect(g,e,tp)
	return Duel.IsExistingTarget(c58270977.spfilter,tp,LOCATION_GRAVE,0,1,g,e,tp) and Duel.GetMZoneCount(tp,g)>0
end
function c58270977.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c58270977.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c58270977.fselect,4,4,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c58270977.fselect,false,4,4,e,tp)
	local b1=sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
	local b2=sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
	local b3=sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
	local b4=sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
	if b1 and b2 and b3 and b4 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c58270977.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c58270977.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c58270977.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c58270977.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c58270977.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) and e:GetLabel()==1 then
		local batk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(batk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		local gc=g:GetFirst()
		while gc do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			gc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			gc:RegisterEffect(e3)
			gc=g:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
end
