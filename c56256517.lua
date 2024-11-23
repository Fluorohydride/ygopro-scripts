--予見通帳
---@param c Card
function c56256517.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,56256517+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c56256517.target)
	e1:SetOperation(c56256517.activate)
	c:RegisterEffect(e1)
end
function c56256517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function c56256517.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>3 then ct=3 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if g:IsExists(aux.NOT(aux.FilterBoolFunction(Card.IsLocation,LOCATION_REMOVED)),1,nil) then return end
	g:KeepAlive()
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(56256517,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc=g:GetNext()
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid,0)
	e1:SetLabelObject(g)
	e1:SetCondition(c56256517.thcon)
	e1:SetOperation(c56256517.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	Duel.RegisterEffect(e1,tp)
end
function c56256517.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c56256517.thfilter(c,fid)
	return c:GetFlagEffectLabel(56256517)==fid
end
function c56256517.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid,ct=e:GetLabel()
	ct=ct+1
	c:SetTurnCounter(ct)
	e:SetLabel(fid,ct)
	if ct==3 then
		local g=e:GetLabelObject()
		if g:FilterCount(c56256517.thfilter,nil,fid)==3 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
