--セグメンタル・ドラゴン
function c15066114.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15066114,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c15066114.ntcon)
	e1:SetOperation(c15066114.ntop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15066114,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c15066114.descon)
	e3:SetTarget(c15066114.destg)
	e3:SetOperation(c15066114.desop)
	c:RegisterEffect(e3)
end
function c15066114.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c15066114.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1300)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1200)
	c:RegisterEffect(e2)
end
function c15066114.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c15066114.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:GetSequence()<5
end
function c15066114.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c15066114.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c15066114.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c15066114.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(c15066114.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
