--殺炎星－ブルキ
function c92572371.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92572371,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,92572371)
	e1:SetCost(c92572371.spcost)
	e1:SetTarget(c92572371.sptg)
	e1:SetOperation(c92572371.spop)
	c:RegisterEffect(e1)
end
function c92572371.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x79,0x7c) and c:IsAbleToGraveAsCost()
end
function c92572371.cfilter1(c,g,tp)
	return g:IsExists(c92572371.cfilter2,1,c,c,tp)
end
function c92572371.cfilter2(c,mc,tp)
	return Duel.GetMZoneCount(tp,Group.FromCards(c,mc))>0
end
function c92572371.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c92572371.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return sg:IsExists(c92572371.cfilter1,1,nil,sg,tp)
		or (Duel.IsPlayerAffectedByEffect(tp,46241344) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) end
	if sg:IsExists(c92572371.cfilter1,1,nil,sg,tp)
		and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=sg:FilterSelect(tp,c92572371.cfilter1,1,1,nil,sg,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=sg:FilterSelect(tp,c92572371.cfilter2,1,1,g1:GetFirst(),g1:GetFirst(),tp)
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_COST)
	end
end
function c92572371.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c92572371.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
