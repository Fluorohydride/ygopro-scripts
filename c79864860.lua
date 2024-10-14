--捕食植物トリフィオヴェルトゥム
---@param c Card
function c79864860.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79864860.ffilter,3,true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79864860.atkval)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79864860,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79864860)
	e2:SetCondition(c79864860.condition)
	e2:SetTarget(c79864860.target)
	e2:SetOperation(c79864860.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,79864861)
	e3:SetCondition(c79864860.spcon)
	e3:SetTarget(c79864860.sptg)
	e3:SetOperation(c79864860.spop)
	c:RegisterEffect(e3)
end
function c79864860.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsOnField()
end
function c79864860.atkfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c79864860.atkval(e,c)
	local g=Duel.GetMatchingGroup(c79864860.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,c)
	local atk=g:GetSum(Card.GetBaseAttack)
	return atk
end
function c79864860.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c79864860.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:IsExists(c79864860.cfilter,1,nil,1-tp) and Duel.GetCurrentChain()==0
		and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79864860.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c79864860.cfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79864860.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79864860.cfilter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c79864860.spfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c79864860.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79864860.spfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c79864860.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79864860.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
