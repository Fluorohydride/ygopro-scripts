--ジュラック・アステロ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	aux.AddCodeList(c,17548456)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DINOSAUR),1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--disable special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON|CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.setfilter(c)
	return c:IsSetCard(0x22) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function s.discfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToRemoveAsCost()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.cfilter(c)
	return c:IsSetCard(0x22) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return s.cfilter(c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(17548456) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end
