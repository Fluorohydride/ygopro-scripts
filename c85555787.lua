--悪のデッキ破壊ウイルス
function c85555787.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND+TIMINGS_CHECK_MONSTER)
	e1:SetCost(c85555787.cost)
	e1:SetTarget(c85555787.target)
	e1:SetOperation(c85555787.activate)
	c:RegisterEffect(e1)
end
function c85555787.costfilter(c,matk)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackBelow(matk)
end
function c85555787.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c85555787.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_DECK)
	local matk=math.min(3000,dc*500)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return matk>0 and Duel.CheckReleaseGroup(tp,c85555787.costfilter,1,nil,matk)
	end
	local g=Duel.SelectReleaseGroup(tp,c85555787.costfilter,1,1,nil,matk)
	local atk=g:GetFirst():GetAttack()
	e:SetLabel(atk)
	Duel.Release(g,REASON_COST)
	local ct=math.floor(atk/500)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c85555787.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	local ct=math.floor(atk/500)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_DECK+LOCATION_HAND,0,ct,ct,nil)
	if g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		for oc in aux.Next(og) do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e3)
		end
	end
	if atk>=2000 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_DRAW)
		e1:SetOperation(c85555787.desop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(c85555787.turncon)
		e2:SetOperation(c85555787.turnop)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
		Duel.RegisterEffect(e2,tp)
		e2:SetLabelObject(e1)
		c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
		c85555787[c]=e2
	end
end
function c85555787.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local c=e:GetHandler()
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		for oc in aux.Next(og) do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e3)
		end
	end
	Duel.ShuffleHand(ep)
end
function c85555787.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c85555787.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end
