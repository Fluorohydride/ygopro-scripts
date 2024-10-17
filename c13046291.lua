--エヴォルド・メガキレラ
---@param c Card
function c13046291.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13046291,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,13046291)
	e1:SetCost(c13046291.spcost)
	e1:SetTarget(c13046291.sptg)
	e1:SetOperation(c13046291.spop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13046291,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,13046292)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c13046291.mattg)
	e2:SetOperation(c13046291.matop)
	c:RegisterEffect(e2)
end
function c13046291.costfilter(c,tp)
	return c:IsRace(RACE_REPTILE) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function c13046291.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c13046291.costfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c13046291.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c13046291.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_DINOSAUR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_EVOLTILE,tp,false,false)
end
function c13046291.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c13046291.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13046291.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13046291.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_VALUE_EVOLTILE,tp,tp,false,false,POS_FACEUP)
	end
end
function c13046291.matfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c13046291.matfilter2(c)
	return c:IsRace(RACE_REPTILE+RACE_DINOSAUR) and c:IsCanOverlay()
end
function c13046291.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13046291.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13046291.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c13046291.matfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13046291.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13046291.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c13046291.matfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.Overlay(tc,sg)
		end
	end
end
