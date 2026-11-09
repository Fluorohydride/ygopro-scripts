--守護竜ピスティ
function c13143275.initial_effect(c)
	c:SetSPSummonOnce(13143275)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c13143275.matfilter,1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13143275.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13143275,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,13143275)
	e2:SetTarget(c13143275.sptg)
	e2:SetOperation(c13143275.spop)
	c:RegisterEffect(e2)
end
function c13143275.matfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_DRAGON)
end
function c13143275.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_DRAGON)
end
function c13143275.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c13143275.spfilter(c,e,tp,zone)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c13143275.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=aux.GetMultiLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c13143275.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c13143275.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13143275.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13143275.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=aux.GetMultiLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if zone~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
