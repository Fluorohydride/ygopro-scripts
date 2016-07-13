--真竜皇バハルストスF
function c82321037.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82321037)
	e1:SetTarget(c82321037.sptg)
	e1:SetOperation(c82321037.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,82321037+1)
	e2:SetCondition(c82321037.thcon)
	e2:SetTarget(c82321037.thtg)
	e2:SetOperation(c82321037.thop)
	c:RegisterEffect(e2)
end
function c82321037.desfilter(c,tc)
	return c~=tc and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)) and c:IsDestructable()
end
function c82321037.desfilter2(c,tc)
	return c82321037.desfilter(c,tc) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c82321037.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c82321037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c82321037.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	local g2=Duel.GetMatchingGroup(c82321037.desfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g1:GetCount()>=2 and g2:GetCount()>=1
		and (ft>0 or Duel.IsExistingMatchingCard(c82321037.desfilter,tp,LOCATION_MZONE,0,1,nil,c)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c82321037.spop(e,tp,eg,ep,ev,re,r,rp)
	if not c82321037.sptg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c82321037.desfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,c)
	if g1:GetCount()<=0 then return end
	local tc1=g1:GetFirst()
	local g2
	if tc1:IsLocation(LOCATION_HAND) and ft<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=Duel.SelectMatchingCard(tp,c82321037.desfilter,tp,LOCATION_MZONE,0,1,1,tc1,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=Duel.SelectMatchingCard(tp,c82321037.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,tc1,c)
	end
	if g2:GetCount()<=0 then return end
	g1:Merge(g2)
	if Duel.Destroy(g1,REASON_EFFECT)==2 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SendtoGrave(c,REASON_RULE)
			return
		end
		local g=Duel.GetMatchingGroup(c82321037.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		if g1:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)==2 and g:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(82321037,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c82321037.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c82321037.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c82321037.thfilter(c,e,tp)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c82321037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c82321037.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82321037.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82321037.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
