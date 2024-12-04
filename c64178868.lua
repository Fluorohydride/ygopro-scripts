--バトル・サバイバー
function c64178868.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64178868,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,64178868)
	e1:SetTarget(c64178868.thtg)
	e1:SetOperation(c64178868.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c64178868.regcon)
	e2:SetOperation(c64178868.regop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e1:SetLabelObject(ng)
	e2:SetLabelObject(ng)
end
function c64178868.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c64178868.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabelObject()
	if c:GetFlagEffect(64178868)==0 then
		sg:Clear()
		c:RegisterFlagEffect(64178868,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
	local g=eg:Filter(Card.IsControler,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(64178868,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
		sg:AddCard(tc)
		tc=g:GetNext()
	end
end
function c64178868.thfilter(c)
	return c:GetFlagEffect(64178868)~=0 and c:IsAbleToHand() and not c:IsCode(64178868) and c:IsLocation(LOCATION_GRAVE)
end
function c64178868.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ng=e:GetLabelObject()
	if chk==0 then return ng and ng:GetCount()>0 and ng:IsExists(c64178868.thfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c64178868.thop(e,tp,eg,ep,ev,re,r,rp)
	local ng=e:GetLabelObject()
	if not ng or ng:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=ng:FilterSelect(tp,aux.NecroValleyFilter(c64178868.thfilter),1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
