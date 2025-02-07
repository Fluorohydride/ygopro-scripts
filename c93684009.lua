--剣闘排斥波
function c93684009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c93684009.tgcon)
	e2:SetTarget(c93684009.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,93684009)
	e3:SetCondition(c93684009.spcon)
	e3:SetTarget(c93684009.sptg)
	e3:SetOperation(c93684009.spop)
	c:RegisterEffect(e3)
end
function c93684009.tgcon(e)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c93684009.tglimit(e,c)
	return c:IsSetCard(0x1019)
end
function c93684009.cfilter(c,tp)
	return c:IsSetCard(0x1019) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function c93684009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c93684009.cfilter,1,nil,tp)
end
function c93684009.filter(c,e,tp)
	return c:IsSetCard(0x1019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and not Duel.IsExistingMatchingCard(c93684009.filter1,tp,LOCATION_MZONE,0,1,c,c:GetRace())
end
function c93684009.filter1(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c93684009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c93684009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c93684009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93684009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
