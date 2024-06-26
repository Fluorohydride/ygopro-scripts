--Flame Swordsdance
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,45231177)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return (c:IsCode(45231177) or aux.IsCodeListed(c,45231177)) and c:IsLevelBelow(7)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.costfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFacedown()
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,e,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.spfilter2(c,e,tp,sc)
	return (c:IsCode(45231177) or aux.IsCodeListed(c,45231177))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,sc)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end