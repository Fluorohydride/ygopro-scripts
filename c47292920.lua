--ディメンジョン・ダイス
---@param c Card
function c47292920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c47292920.spcon)
	e1:SetCost(c47292920.cost)
	e1:SetTarget(c47292920.target)
	e1:SetOperation(c47292920.activate)
	c:RegisterEffect(e1)
end
function c47292920.cfilter(c)
	return c:IsFaceup() and c:IsEffectProperty(aux.EffectCategoryFilter(CATEGORY_DICE))
end
function c47292920.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47292920.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47292920.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c47292920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47292920.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c47292920.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c47292920.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.MonsterEffectCategoryFilter(CATEGORY_DICE))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47292920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c47292920.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47292920.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47292920.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
