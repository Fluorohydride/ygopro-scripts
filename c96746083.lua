--真竜皇アグニマズドV
function c96746083.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,96746083)
	e1:SetTarget(c96746083.sptg)
	e1:SetOperation(c96746083.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,96746084)
	e2:SetCondition(c96746083.thcon)
	e2:SetTarget(c96746083.thtg)
	e2:SetOperation(c96746083.thop)
	c:RegisterEffect(e2)
end
function c96746083.desfilter(c,tc)
	return c~=tc and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)) and c:IsDestructable()
end
function c96746083.desfilter2(c,tc)
	return c96746083.desfilter(c,tc) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c96746083.rmfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp)
end
function c96746083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c96746083.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	local g2=Duel.GetMatchingGroup(c96746083.desfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g1:GetCount()>=2 and g2:GetCount()>=1
		and (ft>0 or Duel.IsExistingMatchingCard(c96746083.desfilter,tp,LOCATION_MZONE,0,1,nil,c)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c96746083.spop(e,tp,eg,ep,ev,re,r,rp)
	if not c96746083.sptg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c96746083.desfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,c)
	if g1:GetCount()<=0 then return end
	local c1=g1:GetFirst()
	local g2
	if c1:IsLocation(LOCATION_HAND) and ft<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=Duel.SelectMatchingCard(tp,c96746083.desfilter,tp,LOCATION_MZONE,0,1,1,c1,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=Duel.SelectMatchingCard(tp,c96746083.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c1,c)
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
		local g=Duel.GetMatchingGroup(c96746083.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,tp)
		if g1:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)==2 and g:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(96746083,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c96746083.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c96746083.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c96746083.thfilter(c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c96746083.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c96746083.thfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c96746083.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96746083.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
