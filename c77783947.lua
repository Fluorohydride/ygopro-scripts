--竜星の極み
function c77783947.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	--synchro effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c77783947.sccon)
	e4:SetCost(c77783947.sccost)
	e4:SetTarget(c77783947.sctg)
	e4:SetOperation(c77783947.scop)
	c:RegisterEffect(e4)
end
function c77783947.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c77783947.mfilter(c)
	return c:IsSetCard(0x9e) and c:IsType(TYPE_MONSTER)
end
function c77783947.mat_group(g,sync,tp)
	return g:IsExists(c77783947.mfilter,1,nil)
end
function c77783947.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77783947.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Auxiliary.SCheckAdditional=c77783947.mat_group
		local res=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		Auxiliary.SCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77783947.scop(e,tp,eg,ep,ev,re,r,rp)
	Auxiliary.SCheckAdditional=c77783947.mat_group
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
	Auxiliary.SCheckAdditional=nil
	if g:GetCount()>0 then
		Auxiliary.SCheckAdditionalLimbo[g:GetFirst():GetFieldID()]=c77783947.mat_group
		Duel.SynchroSummon(tp,g:GetFirst(),nil)
	end
end
