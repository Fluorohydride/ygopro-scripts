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
	e1:SetLabelObject(e2)
end
function c64178868.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c64178868.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsControler,1,nil,tp) then
		local g=eg:Filter(Card.IsControler,nil,tp)
		local ng=Group.CreateGroup()
		ng:KeepAlive()
		ng=e:GetLabelObject()
		if ng then
			ng:Merge(g)
			e:SetLabelObject(ng)
		else
			g:KeepAlive()
			e:SetLabelObject(g)
		end
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(64178868,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
			tc=g:GetNext()
		end
	end
end
function c64178868.thfilter(c)
	return c:GetFlagEffect(64178868)~=0 and c:IsAbleToHand() and not c:IsCode(64178868)
end
function c64178868.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ng=e:GetLabelObject():GetLabelObject()
	if chk==0 then return ng and ng:IsExists(c64178868.thfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c64178868.thop(e,tp,eg,ep,ev,re,r,rp)
	local ng=e:GetLabelObject():GetLabelObject()
	if not ng then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=ng:FilterSelect(tp,aux.NecroValleyFilter(c64178868.thfilter),1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
