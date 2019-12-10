--砂漠の裁き
function c4869446.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c4869446.posop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c4869446.postg)
	c:RegisterEffect(e3)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e3:SetLabelObject(ng)
end
function c4869446.cfilter(c)
	return c:IsFaceup() and c:IsPreviousPosition(POS_FACEDOWN)
end
function c4869446.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabelObject()
	if c:GetFlagEffect(4869446)==0 then
		sg:Clear()
		c:RegisterFlagEffect(4869446,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	local g=eg:Filter(c4869446.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		sg:AddCard(tc)
		tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD)
		tc=g:GetNext()
	end
end
function c4869446.postg(e,c)
	local g=e:GetLabelObject()
	if e:GetHandler():GetFlagEffect(4869446)==0 or g:GetCount()==0 then return false end
	return g:IsContains(c) and c:IsRelateToCard(e:GetHandler())
end
