--熾天蝶
function c91140491.initial_effect(c)
	c:EnableCounterPermit(0x53)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c91140491.lcheck)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c91140491.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91140491,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1,91140491)
	e2:SetCondition(c91140491.ctcon)
	e2:SetTarget(c91140491.cttg)
	e2:SetOperation(c91140491.ctop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c91140491.atkval)
	c:RegisterEffect(e3)
	--special summon insect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,91140491)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(c91140491.spcost)
	e4:SetTarget(c91140491.sptg)
	e4:SetOperation(c91140491.spop)
	c:RegisterEffect(e4)
end
function c91140491.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c91140491.matfilter(c)
	return c:IsLinkRace(RACE_INSECT)
end
function c91140491.matcheck(e,c)
	local ct=c:GetMaterial():FilterCount(c91140491.matfilter,nil)
	e:SetLabel(ct)
end
function c91140491.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c91140491.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabelObject():GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x53)
end
function c91140491.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x53,ct)
	end
end
function c91140491.atkval(e,c)
	return c:GetCounter(0x53)*200
end
function c91140491.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x53,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x53,1,REASON_COST)
end
function c91140491.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c91140491.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c91140491.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c91140491.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91140491.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
