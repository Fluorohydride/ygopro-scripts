--マシュマカロン
function c93749093.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93749093,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,93749093)
	e1:SetCondition(c93749093.spcon)
	e1:SetTarget(c93749093.sptg)
	e1:SetOperation(c93749093.spop)
	c:RegisterEffect(e1)
end
function c93749093.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c93749093.spfilter(c,e,tp)
	return c:IsCode(93749093) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93749093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c93749093.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c93749093.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c93749093.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,ct,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
