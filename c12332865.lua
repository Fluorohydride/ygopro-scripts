--Thron the Disciplined Angel
--Script By JSY1728
function c12332865.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12332865,0))
	e1:SetCategory(CATEGORY_SPECICAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12332865)
	e1:SetCondition(c12332865.spcon)
	e1:SetTarget(c12332865.sptg)
	e1:SetOperation(c12332865.spop)
	c:RegisterEffect(e1)
end
function c12332865.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:GetPreviousControler()==tp and c:GetOriginalRace()==RACE_FAIRY and c:GetOriginalAttribute()==ATTRIBUTE_EARTH
		and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c12332865.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12332865.cfilter,1,nil,tp)
end
function c12332865.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECICAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12332865.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end