--No.107 銀河眼の時空竜
function c88177324.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88177324,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c88177324.negcon)
	e1:SetCost(c88177324.negcost)
	e1:SetTarget(c88177324.negtg)
	e1:SetOperation(c88177324.negop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(c88177324.regcon)
	e2:SetOperation(c88177324.regop)
	c:RegisterEffect(e2)
end
aux.xyz_number[88177324]=107
function c88177324.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c88177324.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88177324.filter2(c)
	return c:IsFaceup() and (not c:IsAttack(c:GetBaseAttack()) or not c:IsDefense(c:GetBaseDefense()))
end
function c88177324.filter3(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c88177324.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
		or Duel.IsExistingMatchingCard(c88177324.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	end
end
function c88177324.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local exc=aux.ExceptThisCard(e)
	local g=Duel.GetMatchingGroup(c88177324.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,exc)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.AdjustInstantly(c)
	g=Duel.GetMatchingGroup(c88177324.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,exc)
	tc=g:GetFirst()
	while tc do
		if not tc:IsAttack(tc:GetBaseAttack()) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if not tc:IsDefense(tc:GetBaseDefense()) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetValue(tc:GetBaseDefense())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(88177324,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end
function c88177324.regcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(88177324)>0
end
function c88177324.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2)
end
