--Dynamist Rex
--NOT A Dinasaur, Lame
--Scripted by Ragna_Edge
function c63251695.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63251695,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c63251695.negcon)
	e2:SetTarget(c63251695.negtg)
	e2:SetOperation(c63251695.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(63251695,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c63251695.effcon)
	e3:SetTarget(c63251695.efftg)
	e3:SetOperation(c63251695.effop)
	c:RegisterEffect(e3)
end
function c63251695.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1e71) and c:IsControler(tp) and c:GetLocation()==LOCATION_ONFIELD
end
function c63251695.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not e:GetHandler():GetFlagEffect(63251695)==0 then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c63251695.tfilter,1,nil) and g:GetFirst()~=e:GetHandler() and Duel.IsChainDisablable(ev)
end
function c63251695.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c63251695.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(63251695,3)) then
		e:GetHandler():RegisterFlagEffect(63251695,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else end
end
function c63251695.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() 
	and ((Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)) or (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0 and e:GetHandler():IsChainAttackable(2,true)))
end
function c63251695.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0x1e71) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0x1e71)
	Duel.Release(g,REASON_COST)
	local opt=0
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 then
		opt=Duel.SelectOption(tp,aux.Stringid(63251695,1))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(63251695,0),aux.Stringid(63251695,1))
	end
	e:SetLabel(opt)
	if opt==0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
	end
end
function c63251695.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
		local sg1=g1:RandomSelect(tp,1)
		local tc=sg1:GetFirst()
		local c=e:GetHandler()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(100)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	else
		local c=e:GetHandler()
		if not c:IsRelateToBattle() then return end
		Duel.ChainAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
