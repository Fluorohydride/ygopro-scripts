--深海の都 マガラニカ
function c26534688.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c26534688.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26534688,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26534688.lvtg)
	e2:SetOperation(c26534688.lvop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26534688,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c26534688.rmcon)
	e3:SetTarget(c26534688.rmtg)
	e3:SetOperation(c26534688.rmop)
	c:RegisterEffect(e3)
end
function c26534688.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_DECK,0,nil,ATTRIBUTE_WATER)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26534688,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26534688,3))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c26534688.lvfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(1)
end
function c26534688.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26534688.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26534688.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26534688.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26534688.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26534688,4))
		local lv=Duel.AnnounceNumber(tp,1,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c26534688.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsSummonPlayer(tp)
end
function c26534688.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and eg:IsExists(c26534688.rmfilter,1,nil,tp)
end
function c26534688.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c26534688.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c26534688.retcon)
	e1:SetOperation(c26534688.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	tc:RegisterFlagEffect(26534688,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
end
function c26534688.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(26534688)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c26534688.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
