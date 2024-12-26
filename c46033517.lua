--マシンナーズ・ルインフォース
---@param c Card
function c46033517.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c46033517.hspcon)
	e2:SetTarget(c46033517.hsptg)
	e2:SetOperation(c46033517.hspop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46033517,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,46033517)
	e3:SetCost(c46033517.negcost)
	e3:SetCondition(c46033517.negcon)
	e3:SetTarget(c46033517.negtg)
	e3:SetOperation(c46033517.negop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46033517,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,46033518)
	e4:SetCondition(c46033517.spcon)
	e4:SetTarget(c46033517.sptg)
	e4:SetOperation(c46033517.spop)
	c:RegisterEffect(e4)
end
function c46033517.hspfilter(c)
	return c:IsLevelAbove(1) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c46033517.hspcheck(g)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,12)
end
function c46033517.hspgcheck(g)
	if g:GetSum(Card.GetLevel)<=12 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,12)
end
function c46033517.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	local g=Duel.GetMatchingGroup(c46033517.hspfilter,tp,LOCATION_GRAVE,0,c)
	aux.GCheckAdditional=c46033517.hspgcheck
	local res=g:CheckSubGroup(c46033517.hspcheck,1,#g)
	aux.GCheckAdditional=nil
	return res
end
function c46033517.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c46033517.hspfilter,tp,LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=c46033517.hspgcheck
	local sg=g:SelectSubGroup(tp,c46033517.hspcheck,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c46033517.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Remove(sg,POS_FACEUP,REASON_SPSUMMON)
	sg:DeleteGroup()
end
function c46033517.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c46033517.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c46033517.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c46033517.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end
function c46033517.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c46033517.spfilter(c,e,tp)
	return c:IsSetCard(0x36) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46033517.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c46033517.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c46033517.spcheck(g)
	return g:GetSum(Card.GetLevel)<=12
end
function c46033517.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local tg=Duel.GetMatchingGroup(c46033517.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=c46033517.spcheck
	local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	aux.GCheckAdditional=nil
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
