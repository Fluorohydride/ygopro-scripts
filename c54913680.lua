--六武ノ書
function c54913680.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c54913680.cost)
	e1:SetTarget(c54913680.target)
	e1:SetOperation(c54913680.activate)
	c:RegisterEffect(e1)
end
function c54913680.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d)
end
function c54913680.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp):Filter(c54913680.rfilter,nil)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheckrel,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,false,2,2,tp)
	Duel.Release(sg,REASON_COST)
end
function c54913680.spfilter(c,e,tp)
	return c:IsCode(63176202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54913680.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then 
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c54913680.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c54913680.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c54913680.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
