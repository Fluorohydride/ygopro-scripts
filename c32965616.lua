--精霊神后 ドリアード
function c32965616.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c32965616.spcon)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c32965616.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--disable special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(32965616,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c32965616.discon)
	e5:SetCost(c32965616.discost)
	e5:SetTarget(c32965616.distg)
	e5:SetOperation(c32965616.disop)
	c:RegisterEffect(e5)
end
function c32965616.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetAttribute)>=6
end
function c32965616.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetAttribute)*500
end
function c32965616.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c32965616.discfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c32965616.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32965616.discfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32965616.discfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32965616.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c32965616.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
