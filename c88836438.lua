--スプライト・スマッシャーズ
function c88836438.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88836438+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c88836438.cost)
	e1:SetTarget(c88836438.target)
	e1:SetOperation(c88836438.activate)
	c:RegisterEffect(e1)
end
function c88836438.spfilter1(c,e,tp)
	return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88836438.spfilter2(c,e,tp)
	return c:IsSetCard(0x179) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88836438.rmfilter(c)
	return (c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)) and c:IsFaceup() and c:IsAbleToRemove()
end
function c88836438.cfilter(c)
	return c:IsSetCard(0x155,0x179,0x180) and c:IsAbleToRemoveAsCost()
end
function c88836438.cfilter2(c,e,tp)
	return c88836438.cfilter(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88836438.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c88836438.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88836438.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c88836438.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp)
	if chk==0 then
		if not b1 and not b2 then
			return Duel.IsExistingMatchingCard(c88836438.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler())
		else
			return Duel.IsExistingMatchingCard(c88836438.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler())
		end
	end
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if not b1 and not b2 then
		g==Duel.SelectMatchingCard(tp,c88836438.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	else
		g==Duel.SelectMatchingCard(tp,c88836438.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c88836438.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88836438.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88836438.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(c88836438.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(88836438,0)},
		{b2,aux.Stringid(88836438,1)},
		{b3,aux.Stringid(88836438,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
	end
end
function c18438874.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88836438.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88836438.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==3 then
		if not Duel.IsExistingMatchingCard(c88836438.rmfilter,tp,LOCATION_MZONE,0,1,nil)
			or not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c88836438.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
		g1:Merge(g2)
		Duel.HintSelection(g1)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end
