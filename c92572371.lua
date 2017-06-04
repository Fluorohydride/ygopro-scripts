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
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and (c:IsSetCard(0x79) or c:IsSetCard(0x7c)) and c:IsAbleToGraveAsCost()
end
function c92572371.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c92572371.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c92572371.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return sg:GetCount()>=2
		and (ft>0 or (ct<3 and sg:IsExists(c92572371.mzfilter,ct,nil))) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,c92572371.mzfilter,ct,ct,nil)
		if ct<2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=sg:Select(tp,2-ct,2-ct,g)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
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
