--ドレミコード・スケール
function c53265336.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53265336+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53265336.target)
	e1:SetOperation(c53265336.operation)
	c:RegisterEffect(e1)
end
function c53265336.cfilter(c)
	return c:IsSetCard(0x162) and c:GetOriginalType()&TYPE_PENDULUM>0 and c:IsFaceup()
end
function c53265336.tpfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c53265336.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x162) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53265336.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c53265336.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local b1=ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c53265336.tpfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0
	local b2=ct>=5 and Duel.IsExistingMatchingCard(c53265336.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=ct>=7 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)>0
	if chk==0 then return b1 or b2 or b3 end
end
function c53265336.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53265336.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local b1=ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c53265336.tpfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(53265336,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,1,nil)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=Duel.SelectMatchingCard(tp,c53265336.tpfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
	g=Duel.GetMatchingGroup(c53265336.cfilter,tp,LOCATION_ONFIELD,0,nil)
	ct=g:GetClassCount(Card.GetCode)
	local b2=ct>=5 and Duel.IsExistingMatchingCard(c53265336.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(53265336,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c53265336.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	g=Duel.GetMatchingGroup(c53265336.cfilter,tp,LOCATION_ONFIELD,0,nil)
	ct=g:GetClassCount(Card.GetCode)
	local b3=ct>=7 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)>0
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(53265336,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
