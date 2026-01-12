--The Fallen ＆ The Virtuous
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return aux.IsCodeListed(c,68468459) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.cfilter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1d7) and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then
			return chkc:IsOnField() and chkc:IsFaceup() and chkc~=e:GetHandler()
		elseif e:GetLabel()==2 then
			return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp)
		end
		return false
	end
	local b1=(Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil) or not e:IsCostChecked())
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_COST)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DESTROY)
		end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() then return end
	if e:GetLabel()==1 and tc:IsOnField() then
		Duel.Destroy(tc,REASON_EFFECT)
	elseif e:GetLabel()==2 and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
