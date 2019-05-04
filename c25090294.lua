--ブルーメンブラット
function c25090294.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25090294.cost)
	e1:SetTarget(c25090294.target)
	e1:SetOperation(c25090294.activate)
	c:RegisterEffect(e1)
end
function c25090294.costfilter(c,tp)
	return c:IsCode(62107981)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c25090294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c25090294.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c25090294.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c25090294.filter(c,e,tp)
	return c:IsCode(51085303) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c25090294.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c25090294.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c25090294.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25090294.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
