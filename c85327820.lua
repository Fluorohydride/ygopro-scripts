--Aiの儀式
function c85327820.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c85327820.target)
	e1:SetOperation(c85327820.activate)
	c:RegisterEffect(e1)
end
function c85327820.filter(c,e,tp)
	return c:IsRace(RACE_CYBERSE)
end
function c85327820.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x135)
end
function c85327820.mfilter(c)
	return c:IsSetCard(0x135)
end
function c85327820.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0x135)
		local mg2=nil
		if Duel.IsExistingMatchingCard(c85327820.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c85327820.mfilter)
		end
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c85327820.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if Duel.IsExistingMatchingCard(c85327820.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c85327820.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0x135)
	local mg2=nil
	if e:GetLabel()==1 then
		mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c85327820.mfilter)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c85327820.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
