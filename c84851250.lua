--WW－ブリザード・ベル
function c84851250.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84851250,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c84851250.ntcon)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84851250,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,84851250)
	e2:SetCondition(c84851250.damcon)
	e2:SetCost(c84851250.damcost)
	e2:SetTarget(c84851250.damtg)
	e2:SetOperation(c84851250.damop)
	c:RegisterEffect(e2)
end
function c84851250.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf0)
end
function c84851250.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(c84851250.ntfilter,tp,LOCATION_MZONE,0,nil)
end
function c84851250.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf0) and not c:IsCode(84851250)
end
function c84851250.damcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c84851250.damfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c84851250.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c84851250.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c84851250.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
