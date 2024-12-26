--騎士の称号
---@param c Card
function c87210505.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c87210505.cost)
	e1:SetTarget(c87210505.target)
	e1:SetOperation(c87210505.activate)
	c:RegisterEffect(e1)
end
function c87210505.costfilter(c,tp)
	return c:IsFaceup() and c:IsCode(46986414) and Duel.GetMZoneCount(tp,c)>0
end
function c87210505.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c87210505.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c87210505.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c87210505.spfilter(c,e,tp)
	return c:IsCode(50725996) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c87210505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c87210505.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c87210505.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87210505.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
