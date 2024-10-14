--ウサミミ導師
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOnField() and rc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and not rc:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re:GetHandler():IsCanAddCounter(0x1065,1)
		and c:GetFlagEffect(id)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1065)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsFaceup() and rc:IsRelateToEffect(re) and rc:AddCounter(0x1065,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetCondition(s.indes)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		rc:RegisterEffect(e1)
	end
end
function s.indes(e)
	return e:GetHandler():GetCounter(0x1065)>0
end
function s.filter(c)
	return c:GetCounter(0x1065)>0 and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and chkc~=c end
	if chk==0 then return c:IsAbleToRemove()
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g+c,2,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local ct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
		local og=Duel.GetOperatedGroup()
		for oc in aux.Next(og) do
			oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,ct,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount()+1)
		e1:SetLabelObject(og)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	if Duel.GetTurnCount()<ct then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil,fid)
	g:DeleteGroup()
	for tc in aux.Next(sg) do Duel.ReturnToField(tc) end
end
