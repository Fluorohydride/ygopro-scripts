--幻奏の華楽聖ブルーム・ハーモニスト
---@param c Card
function c34974462.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34974462,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,34974462)
	e1:SetCondition(c34974462.spcon)
	e1:SetCost(c34974462.spcost)
	e1:SetTarget(c34974462.sptg)
	e1:SetOperation(c34974462.spop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c34974462.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(34974462,ACTIVITY_SPSUMMON,c34974462.counterfilter)
end
function c34974462.counterfilter(c)
	return c:IsSetCard(0x9b)
end
function c34974462.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c34974462.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(34974462,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c34974462.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c34974462.splimit(e,c)
	return not c:IsSetCard(0x9b)
end
function c34974462.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x9b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c34974462.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local g=Duel.GetMatchingGroup(c34974462.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ft>1 and g:GetClassCount(Card.GetLevel)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c34974462.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local g=Duel.GetMatchingGroup(c34974462.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 and g:GetClassCount(Card.GetLevel)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		if sg and sg:GetCount()==2 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
		end
	end
end
function c34974462.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9b)
end
function c34974462.actcon(e)
	local a=Duel.GetAttacker()
	return a and c34974462.cfilter(a) and e:GetHandler():GetLinkedGroup():IsContains(a)
end
