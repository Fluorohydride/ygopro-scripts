--毒蛇の怨念
---@param c Card
function c1683982.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c1683982.atktg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c1683982.regcon)
	e3:SetOperation(c1683982.regop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c1683982.regcon2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1683982,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_CUSTOM+1683982)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,1683982)
	e5:SetTarget(c1683982.sptg)
	e5:SetOperation(c1683982.spop)
	c:RegisterEffect(e5)
	--return to grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1683982,2))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,1683983)
	e6:SetCondition(c1683982.tgcon)
	e6:SetTarget(c1683982.tgtg)
	e6:SetOperation(c1683982.tgop)
	c:RegisterEffect(e6)
end
function c1683982.atktg(e,c)
	return not c:IsRace(RACE_REPTILE)
end
function c1683982.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousRaceOnField()&RACE_REPTILE~=0
end
function c1683982.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1683982.cfilter,1,nil,tp)
end
function c1683982.cfilter2(c,tp)
	return not c:IsReason(REASON_BATTLE) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousRaceOnField()&RACE_REPTILE~=0 and c:IsRace(RACE_REPTILE) and c:IsPreviousPosition(POS_FACEUP)
end
function c1683982.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1683982.cfilter2,1,nil,tp)
end
function c1683982.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+1683982,e,0,tp,0,0)
end
function c1683982.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1683982.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1683982.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1683982.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1683982.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1683982.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c1683982.filter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsFaceup()
end
function c1683982.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1683982.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c1683982.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c1683982.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1683982.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
