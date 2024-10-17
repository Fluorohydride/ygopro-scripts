--インフェルノイド・リリス
---@param c Card
function c23440231.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c23440231.spcon)
	e2:SetTarget(c23440231.sptg)
	e2:SetOperation(c23440231.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c23440231.destg)
	e3:SetOperation(c23440231.desop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c23440231.negcon)
	e4:SetCost(c23440231.negcost)
	e4:SetTarget(aux.nbtg)
	e4:SetOperation(c23440231.negop)
	c:RegisterEffect(e4)
end
function c23440231.spfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c23440231.sumfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c23440231.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c23440231.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=Duel.GetMatchingGroup(c23440231.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c23440231.lv_or_rk)
	if sum>8 then return false end
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(34822850) then loc=loc+LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c23440231.spfilter,tp,loc,0,c)
	return g:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c23440231.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(34822850) then loc=loc+LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c23440231.spfilter,tp,loc,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c23440231.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c23440231.desfilter(c)
	return (c:IsFacedown() or not c:IsSetCard(0xc5)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c23440231.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23440231.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c23440231.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23440231.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23440231.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c23440231.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c23440231.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c23440231.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c23440231.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c23440231.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c23440231.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
