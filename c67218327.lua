--SIMMタブラス
function c67218327.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67218327,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67218327)
	e1:SetCost(c67218327.cost)
	e1:SetTarget(c67218327.target)
	e1:SetOperation(c67218327.operation)
	c:RegisterEffect(e1)
end
function c67218327.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c67218327.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkState()
end
function c67218327.filter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLevel(4) and c:IsAbleToHand()
end
function c67218327.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c67218327.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then
		local lg=Duel.GetMatchingGroup(c67218327.lkfilter,tp,LOCATION_MZONE,0,nil)
		local zone=0
		for tc in aux.Next(lg) do
			zone=bit.bor(zone,bit.band(tc:GetLinkedZone(),0x1f))
		end
		return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c67218327.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c67218327.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67218327.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lg=Duel.GetMatchingGroup(c67218327.lkfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,bit.band(tc:GetLinkedZone(),0x1f))
	end
	if zone~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
