--ボンディング－H2O
function c45898858.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c45898858.cost)
	e1:SetTarget(c45898858.target)
	e1:SetOperation(c45898858.activate)
	c:RegisterEffect(e1)
end
function c45898858.costfilter(c,tp)
	return c:IsCode(22587018,58071123) and (c:IsControler(tp) or c:IsFaceup())
end
function c45898858.fcheck(c,mg,sg,code,...)
	if not c:IsCode(code) then return false end
	if ... then
		sg:AddCard(c)
		local res=mg:IsExists(c45898858.fcheck,1,sg,mg,sg,...)
		sg:RemoveCard(c)
		return res
	else return true end
end
function c45898858.fselect(g,tp,sg)
	if g:IsExists(c45898858.fcheck,1,nil,g,sg,22587018,22587018,58071123) and Duel.GetMZoneCount(tp,g)>0 then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c45898858.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local sg=Group.CreateGroup()
	local g=Duel.GetReleaseGroup(tp):Filter(c45898858.costfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c45898858.fselect,3,3,tp,sg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c45898858.fselect,false,3,3,tp,sg)
	Duel.Release(rg,REASON_COST)
end
function c45898858.filter(c,e,tp)
	return c:IsCode(85066822) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c45898858.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c45898858.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c45898858.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45898858.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
