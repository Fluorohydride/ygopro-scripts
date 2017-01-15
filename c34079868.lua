--真竜剣士マスターP
function c34079868.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c34079868.spcon)
	e1:SetOperation(c34079868.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34079868,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c34079868.discon)
	e2:SetTarget(c34079868.distg)
	e2:SetOperation(c34079868.disop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34079868,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c34079868.condition)
	e3:SetTarget(c34079868.target)
	e3:SetOperation(c34079868.operation)
	c:RegisterEffect(e3)
end
function c34079868.rfilter(c,tp)
	return c:IsSetCard(0xc7) and Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,c,0xda)
end
function c34079868.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c34079868.rfilter,1,nil,tp)
end
function c34079868.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectReleaseGroup(tp,c34079868.rfilter,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,g1:GetFirst(),0xda)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c34079868.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c34079868.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c34079868.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c34079868.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c34079868.spfilter1(c,e,tp)
	return c:IsSetCard(0xc7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c34079868.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c34079868.spfilter2(c,e,tp)
	return c:IsSetCard(0xda) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34079868.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c34079868.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c34079868.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c34079868.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c34079868.spfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
