--聖なる心のバリア －マインドフォース－
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(s.nbcon)
	c:RegisterEffect(e4)
	--cannot negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(s.efilter)
	Duel.RegisterEffect(e5,0)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e6,0)
end
function s.nbcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,5,nil)
end
function s.efilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te then return false end
	if te:GetOwner()~=e:GetOwner() then return false end
	if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,5,nil)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return false end
	if Duel.GetTurnPlayer()==tp then
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		if (LOCATION_HAND+LOCATION_ONFIELD)&loc~=0 then return true end
	end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return Duel.GetTurnPlayer()~=tp and tg:IsContains(Duel.GetAttacker())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local flag=false
	for tc in aux.Next(g) do
		if tc:IsCanBeDisabledByEffect(e,false) then
			flag=true
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
	Duel.AdjustInstantly()
	if flag and #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,5,nil)
end
