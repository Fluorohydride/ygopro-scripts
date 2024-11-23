--X・Y・Zコンバイン
---@param c Card
function c95471006.initial_effect(c)
	aux.AddCodeList(c,62651957,65622692,64500000)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95471006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,95471006)
	e1:SetCondition(c95471006.spcon)
	e1:SetTarget(c95471006.sptg)
	e1:SetOperation(c95471006.spop)
	c:RegisterEffect(e1)
	--spsummon from removed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95471006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,95471007)
	e2:SetCost(c95471006.sprcost)
	e2:SetTarget(c95471006.sprtg)
	e2:SetOperation(c95471006.sprop)
	c:RegisterEffect(e2)
end
c95471006.has_text_type=TYPE_UNION
function c95471006.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsType(TYPE_UNION) and c:IsPreviousControler(tp) and c:IsFaceup()
end
function c95471006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95471006.cfilter,1,nil,tp)
end
function c95471006.spfilter(c,e,tp)
	return c:IsCode(62651957,65622692,64500000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95471006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95471006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95471006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95471006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95471006.sprcfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c95471006.sprcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95471006.sprcfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c95471006.sprcfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c95471006.sprfilter(c,e,tp)
	return c:IsCode(62651957,65622692,64500000) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95471006.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95471006.sprfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local max=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetMZoneCount(tp)<2 then max=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,max,tp,LOCATION_REMOVED)
end
function c95471006.sprop(e,tp,eg,ep,ev,re,r,rp)
	local max=2
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then max=1 end
	local g=Duel.GetMatchingGroup(c95471006.sprfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
