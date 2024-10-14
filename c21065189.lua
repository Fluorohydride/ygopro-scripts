--ファイアウォール・X・ドラゴン
---@param c Card
function c21065189.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21065189.atkcon)
	e1:SetValue(c21065189.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21065189,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21065189.cost)
	e2:SetTarget(c21065189.target)
	e2:SetOperation(c21065189.operation)
	c:RegisterEffect(e2)
end
function c21065189.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c21065189.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c21065189.atkval(e,c)
	local g=Duel.GetMatchingGroup(c21065189.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	return g:GetSum(Card.GetLink)*500
end
function c21065189.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c21065189.get_zone(c,seq)
	local zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.replace(zone,0x1,seq+1) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.replace(zone,0x1,seq-1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,0) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,4) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,3) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,2) end
	return zone
end
function c21065189.spfilter(c,e,tp,seq)
	if not (c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:IsLink(4)) then return false end
	local zone=c21065189.get_zone(c,seq)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c21065189.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local seq=e:GetHandler():GetSequence()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21065189.spfilter(chkc,e,tp,seq) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21065189.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,seq) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21065189.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,seq)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21065189.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsRelateToEffect(e) then
		local zone=c21065189.get_zone(tc,c:GetSequence())
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
