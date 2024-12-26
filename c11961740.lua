--タイムカプセル
---@param c Card
function c11961740.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11961740.target)
	e1:SetOperation(c11961740.activate)
	c:RegisterEffect(e1)
end
function c11961740.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11961740.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp,POS_FACEDOWN):GetFirst()
		if rc and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			rc:RegisterFlagEffect(11961740,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
			c:CancelToGrave()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetCondition(c11961740.thcon)
			e1:SetOperation(c11961740.thop)
			e1:SetLabel(fid,0)
			e1:SetLabelObject(rc)
			c:RegisterEffect(e1)
		end
	end
end
function c11961740.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c11961740.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid,ct=e:GetLabel()
	local tc=e:GetLabelObject()
	ct=ct+1
	c:SetTurnCounter(ct)
	e:SetLabel(fid,ct)
	if ct~=2 then return end
	if Duel.Destroy(c,REASON_EFFECT)>0 and tc:GetFlagEffectLabel(11961740)==fid then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
