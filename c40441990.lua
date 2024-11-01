--星遺物－『星鍵』
---@param c Card
function c40441990.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40441990,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40441990)
	e1:SetCost(c40441990.sumcost)
	e1:SetTarget(c40441990.sumtg)
	e1:SetOperation(c40441990.sumop)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40441990,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,40441991)
	e2:SetTarget(c40441990.tetg)
	e2:SetOperation(c40441990.teop)
	c:RegisterEffect(e2)
end
function c40441990.costfilter(c)
	return c:IsSetCard(0xfe) and c:IsDiscardable()
end
function c40441990.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40441990.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c40441990.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c40441990.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function c40441990.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,40441990)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(40441990,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,40441990,RESET_PHASE+PHASE_END,0,1)
end
function c40441990.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsType(TYPE_LINK) and bc:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,bc,1,0,0)
end
function c40441990.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoDeck(bc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
