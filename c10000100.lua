--暗黒の太陽神－ラーの翼神竜
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,10000010,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1ef),3,true,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.tgcon)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.atkcost)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.cfilter(c)
	return c:IsSetCard(0x1ef) and c:IsDiscardable()
end
function s.tgfilter(c)
	return c:GetSequence()<5 and c:IsAbleToGrave()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local rt=Duel.GetMatchingGroupCount(s.tgfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	local ct=Duel.DiscardHand(tp,s.cfilter,1,rt,REASON_COST+REASON_DISCARD,nil)
	e:SetLabel(ct)
end
function s.fdfilter(c,i)
	return c:IsAbleToGrave() and c:GetSequence()==i
end
function s.tgfilter2(c,dis)
	return c:IsAbleToGrave() and (2^c:GetSequence())*0x10000&dis~=0
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fdzone=0
	for i=0,4 do
		if Duel.IsExistingMatchingCard(s.fdfilter,tp,0,LOCATION_MZONE,1,nil,i) then
			fdzone=fdzone|1<<i
		end
	end
	if chk==0 then return fdzone&0x1f>0 end
	local dis=Duel.SelectField(tp,e:GetLabel(),0,LOCATION_MZONE,(~fdzone|0x60)<<16)
	e:SetLabel(dis)
	local g=Duel.GetMatchingGroup(s.tgfilter2,tp,0,LOCATION_MZONE,nil,dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dis=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.tgfilter2,tp,0,LOCATION_MZONE,nil,dis)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE,1-tp)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-1,true) end
	e:SetLabel(lp-1)
	Duel.PayLPCost(tp,lp-1,true)
end
function s.atkfilter(c)
	return c:IsSetCard(0x1ef) and c:IsType(TYPE_MONSTER) and c:GetTextAttack()>0
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToChain() then
		local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_GRAVE,0,nil)
		local atk=g:GetSum(Card.GetAttack)+e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
