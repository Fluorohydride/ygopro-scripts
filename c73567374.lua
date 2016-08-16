--フォース・リリース
function c73567374.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73567374.target)
	e1:SetOperation(c73567374.operation)
	c:RegisterEffect(e1)
end
function c73567374.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState()
end
function c73567374.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73567374.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c73567374.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c73567374.filter2(c,e)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c73567374.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c73567374.filter2,tp,LOCATION_MZONE,0,nil,e)
	local tc=g:GetFirst()
	local fid=c:GetFieldID()
	while tc do
		tc:EnableDualState()
		tc:RegisterFlagEffect(73567374,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		tc=g:GetNext()
	end
	g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(g)
	e2:SetCondition(c73567374.flipcon)
	e2:SetOperation(c73567374.flipop)
	Duel.RegisterEffect(e2,tp)
end
function c73567374.flipfilter(c,fid)
	return c:GetFlagEffectLabel(73567374)==fid
end
function c73567374.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c73567374.flipfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c73567374.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c73567374.flipfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.ChangePosition(dg,POS_FACEDOWN_DEFENSE)
end
