--未界域のツチノコ
function c99745551.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99745551,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c99745551.spcost)
	e1:SetTarget(c99745551.sptg)
	e1:SetOperation(c99745551.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99745551,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetCountLimit(1,99745551)
	e2:SetTarget(c99745551.sptg2)
	e2:SetOperation(c99745551.spop2)
	c:RegisterEffect(e2)
end
function c99745551.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c99745551.spfilter(c,e,tp)
	return c:IsCode(99745551) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99745551.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99745551.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g<1 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_DISCARD+REASON_EFFECT)~=0 and not tc:IsCode(99745551)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local spg=Duel.GetMatchingGroup(c99745551.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if spg:GetCount()<=0 then return end
		local sg=spg:GetFirst()
		if spg:GetCount()~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=spg:Select(tp,1,1,nil)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c99745551.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99745551.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
