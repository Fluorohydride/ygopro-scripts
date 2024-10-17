--クリムゾン・リゾネーター
---@param c Card
function c34761841.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34761841,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,34761841)
	e1:SetCondition(c34761841.spcon1)
	e1:SetCost(c34761841.spcost)
	e1:SetTarget(c34761841.sptg1)
	e1:SetOperation(c34761841.spop1)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34761841,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,34761842)
	e2:SetCondition(c34761841.spcon2)
	e2:SetCost(c34761841.spcost)
	e2:SetTarget(c34761841.sptg2)
	e2:SetOperation(c34761841.spop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(34761841,ACTIVITY_SPSUMMON,c34761841.counterfilter)
end
function c34761841.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
		or (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO))
end
function c34761841.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c34761841.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(34761841,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c34761841.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c34761841.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
		and not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO))
end
function c34761841.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c34761841.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c34761841.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO)
end
function c34761841.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c34761841.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==1
end
function c34761841.spfilter(c,e,tp)
	return c:IsSetCard(0x57) and not c:IsCode(34761841) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34761841.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c34761841.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c34761841.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ct=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c34761841.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
