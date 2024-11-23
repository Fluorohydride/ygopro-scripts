--タイラント・プランテーション
---@param c Card
function c90814668.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90814668+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c90814668.cost)
	e1:SetTarget(c90814668.target)
	e1:SetOperation(c90814668.activate)
	c:RegisterEffect(e1)
end
function c90814668.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c90814668.cfilter(c,e,tp)
	return c:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c90814668.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c90814668.spfilter(c,e,tp,race,att)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOriginalRace()==race and c:GetOriginalAttribute()==att
end
function c90814668.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c90814668.cfilter,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c90814668.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetOriginalRace(),g:GetFirst():GetOriginalAttribute())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90814668.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local race,att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c90814668.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,race,att)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
