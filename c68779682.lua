--ラビュリンス・バラージュ
function c68779682.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c68779682.condition)
	e1:SetTarget(c68779682.target)
	e1:SetOperation(c68779682.activate)
	c:RegisterEffect(e1)
end
function c68779682.condition(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	local rc=re:GetHandler()
	return rp==tp and not rc:IsStatus(STATUS_ACT_FROM_HAND) and rc:GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and code1~=68779682 and code2~=68779682
end
---dynamic target
function c68779682.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():CheckActivateEffect(false,true,false)~=nil end
	local te,ceg,cep,cev,cre,cr,crp=re:GetHandler():CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c68779682.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local ct=1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(c68779682.damval)
		if Duel.GetTurnPlayer()==1-tp then
			ct=2
		end
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c68779682.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp==e:GetOwnerPlayer() then return 0
	else return val end
end
