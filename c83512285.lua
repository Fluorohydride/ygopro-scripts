--ハイパー・ギャラクシー
---@param c Card
function c83512285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,83512285+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c83512285.cost)
	e1:SetTarget(c83512285.target)
	e1:SetOperation(c83512285.activate)
	c:RegisterEffect(e1)
end
function c83512285.costfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsAttackAbove(2000) and not c:IsCode(93717133) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c83512285.rfilter,tp,0,LOCATION_MZONE,1,c)
end
function c83512285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c83512285.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c83512285.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c83512285.spfilter(c,e,tp)
	return c:IsCode(93717133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83512285.rfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000) and c:IsReleasableByEffect()
end
function c83512285.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c83512285.rfilter(chkc) end
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingTarget(c83512285.rfilter,tp,0,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(c83512285.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SelectTarget(tp,c83512285.rfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c83512285.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c83512285.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
