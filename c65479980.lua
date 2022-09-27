--S－Force ドッグ・タッグ
function c65479980.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65479980,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65479980)
	e1:SetCondition(c65479980.spcon)
	e1:SetTarget(c65479980.sptg)
	e1:SetOperation(c65479980.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c65479980.actcon)
	e3:SetTarget(c65479980.actlimit)
	c:RegisterEffect(e3)
end
function c65479980.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156)
end
function c65479980.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function c65479980.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65479980.cfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c65479980.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65479980.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65479980.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65479980.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c65479980.actfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c65479980.actlimit(e,c)
	local face=c:GetColumnGroup()
	return face:IsExists(c65479980.actfilter,1,nil,e:GetHandlerPlayer())
end
