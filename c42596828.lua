--龍狸燈
function c42596828.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42596828,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c42596828.defcost)
	e1:SetOperation(c42596828.defop)
	c:RegisterEffect(e1)
	--use DEF for damage calc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42596828,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c42596828.atkcon)
	e2:SetCost(c42596828.atkcost)
	e2:SetOperation(c42596828.atkop)
	c:RegisterEffect(e2)
end
function c42596828.defcostfilter(c)
	return c:IsDiscardable() and c:IsRace(RACE_WYRM)
end
function c42596828.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42596828.defcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c42596828.defcostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c42596828.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c42596828.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac,bc=Duel.GetBattleMonster(tp)
	return bc and (ac==c or bc==c)
		and ac:IsPosition(POS_ATTACK) and ac:IsDefenseAbove(0)
		and bc:IsPosition(POS_ATTACK) and bc:IsDefenseAbove(0)
end
function c42596828.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(42596828)==0 end
	c:RegisterFlagEffect(42596828,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c42596828.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsRelateToBattle() and d and d:IsRelateToBattle() then
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_SINGLE)
		ea:SetCode(EFFECT_SET_BATTLE_ATTACK)
		ea:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ea:SetValue(a:GetDefense())
		a:RegisterEffect(ea,true)
		local ed=Effect.CreateEffect(c)
		ed:SetType(EFFECT_TYPE_SINGLE)
		ed:SetCode(EFFECT_SET_BATTLE_ATTACK)
		ed:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ed:SetValue(d:GetDefense())
		d:RegisterEffect(ed,true)
	end
end
