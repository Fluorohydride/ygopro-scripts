--デコード・エンド
---@param c Card
function c33062423.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33062423,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33062423+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33062423.target)
	e1:SetOperation(c33062423.operation)
	c:RegisterEffect(e1)
end
function c33062423.filter(c)
	return c:IsFaceup() and c:IsCode(1861629) and c:GetLinkedGroupCount()>0
end
function c33062423.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33062423.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33062423.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33062423.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33062423.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local ct=tc:GetLinkedGroupCount()
	if ct>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*500)
		tc:RegisterEffect(e1)
	end
	if ct>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetOwnerPlayer(tp)
		e2:SetCondition(c33062423.rmcon)
		e2:SetOperation(c33062423.rmop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
	end
	if ct==3 then
		tc:RegisterFlagEffect(33062423,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(33062423,1))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_BATTLED)
		e3:SetLabelObject(tc)
		e3:SetCondition(c33062423.descon)
		e3:SetTarget(c33062423.destg)
		e3:SetOperation(c33062423.desop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c33062423.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tp==e:GetOwnerPlayer() and tc and tc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33062423.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c33062423.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	return tc:GetFlagEffect(33062423)~=0 and bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and tc:IsStatus(STATUS_OPPO_BATTLE)
end
function c33062423.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c33062423.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
