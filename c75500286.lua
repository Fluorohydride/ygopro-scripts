--封印の黄金櫃
function c75500286.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75500286.target)
	e1:SetOperation(c75500286.activate)
	c:RegisterEffect(e1)
end
function c75500286.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c75500286.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local fid=c:GetFieldID()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		rc:RegisterFlagEffect(75500286,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetLabel(fid,0)
		e1:SetLabelObject(rc)
		e1:SetCondition(c75500286.thcon)
		e1:SetOperation(c75500286.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75500286.thcon(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	return Duel.GetTurnPlayer()==tp and tc:GetFlagEffectLabel(75500286)==fid
end
function c75500286.thop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local tc=e:GetLabelObject()
	ct=ct+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(fid,ct)
	if ct~=2 then return end
	if tc:GetFlagEffectLabel(75500286)==fid then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
