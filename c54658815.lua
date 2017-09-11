--リモート・リボーン
function c54658815.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c54658815.target)
	e1:SetOperation(c54658815.activate)
	c:RegisterEffect(e1)
end
function c54658815.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c54658815.filter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone)
end
function c54658815.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=0
	local lg=Duel.GetMatchingGroup(c54658815.lkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,bit.rshift(tc:GetLinkedZone(),16))
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c54658815.filter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.IsExistingTarget(c54658815.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c54658815.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c54658815.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local zone=0
		local lg=Duel.GetMatchingGroup(c54658815.lkfilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(lg) do
			zone=bit.bor(zone,bit.rshift(tc:GetLinkedZone(),16))
		end
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP,zone)
	end
end
