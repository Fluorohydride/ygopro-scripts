--守護竜アガーペイン
function c59537380.initial_effect(c)
	c:SetSPSummonOnce(59537380)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c59537380.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59537380,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,59537380)
	e2:SetTarget(c59537380.sptg)
	e2:SetOperation(c59537380.spop)
	c:RegisterEffect(e2)
end
function c59537380.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_DRAGON)
end
function c59537380.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c59537380.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c59537380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=aux.GetMultiLinkedZone(tp)
	if chk==0 then return zone~=0 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c59537380.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59537380.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=aux.GetMultiLinkedZone(tp)
	if Duel.GetLocationCountFromEx(tp)<=0 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59537380.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
