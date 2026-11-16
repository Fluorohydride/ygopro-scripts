--ディメンション・ミラージュ
function c80560728.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c80560728.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(c80560728.tgcon)
	e2:SetOperation(c80560728.tgop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--mulit attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80560728,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c80560728.atcon)
	e3:SetCost(c80560728.atcost)
	e3:SetOperation(c80560728.atop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c80560728.descon)
	e4:SetOperation(c80560728.desop)
	c:RegisterEffect(e4)
end
function c80560728.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c80560728.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80560728.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80560728.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80560728.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c80560728.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c80560728.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c80560728.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local at=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return at==tc and d and d:IsRelateToBattle()
end
function c80560728.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c80560728.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80560728.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80560728.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80560728.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_FIRST_ATTACK)
		tc:RegisterEffect(e2)
		Duel.ChainAttack()
	end
end
function c80560728.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c80560728.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
