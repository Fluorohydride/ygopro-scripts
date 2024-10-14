--サウザンドエナジー
---@param c Card
function c5703682.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5703682.target)
	e1:SetOperation(c5703682.activate)
	c:RegisterEffect(e1)
end
function c5703682.filter(c)
	local tpe=c:GetType()
	return c:IsFaceup() and bit.band(tpe,TYPE_NORMAL)~=0 and bit.band(tpe,TYPE_TOKEN)==0 and c:IsLevel(2)
end
function c5703682.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5703682.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c5703682.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c5703682.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local batk=tc:GetBaseAttack()
		local bdef=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(batk+1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		e2:SetValue(bdef+1000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetCountLimit(1)
	de:SetCondition(c5703682.descon)
	de:SetOperation(c5703682.desop)
	de:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(de,tp)
end
function c5703682.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLevel(2)
end
function c5703682.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5703682.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c5703682.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c5703682.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
