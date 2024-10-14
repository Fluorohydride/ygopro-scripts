--ブラックフェザー・アサルト・ドラゴン
---@param c Card
function c73218989.initial_effect(c)
	aux.AddCodeList(c,9012916)
	c:EnableCounterPermit(0x10)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73218989,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c73218989.spcon)
	e2:SetTarget(c73218989.sptg)
	e2:SetOperation(c73218989.spop)
	c:RegisterEffect(e2)
	--add counter and damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c73218989.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c73218989.damcon)
	e4:SetOperation(c73218989.damop)
	c:RegisterEffect(e4)
	--destory
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(73218989,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c73218989.descon)
	e5:SetCost(c73218989.descost)
	e5:SetTarget(c73218989.destg)
	e5:SetOperation(c73218989.desop)
	c:RegisterEffect(e5)
end
c73218989.material_type=TYPE_SYNCHRO
function c73218989.mfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function c73218989.mfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c73218989.mfilter2(c)
	return c:IsCode(9012916)
end
function c73218989.fselect(g,c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and aux.gffcheck(g,c73218989.mfilter1,nil,c73218989.mfilter2,nil)
end
function c73218989.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c73218989.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(c73218989.fselect,2,2,c,tp)
end
function c73218989.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c73218989.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c73218989.fselect,true,2,2,c,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c73218989.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c73218989.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) then
		e:GetHandler():RegisterFlagEffect(73218989,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function c73218989.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetLP(1-tp)>0 and c:GetFlagEffect(73218989)~=0 and re:IsActiveType(TYPE_MONSTER)
end
function c73218989.damop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x10,1)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end
function c73218989.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c73218989.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and c:GetCounter(0x10)>=4 end
	Duel.Release(c,REASON_COST)
end
function c73218989.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c73218989.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
