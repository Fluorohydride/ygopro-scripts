--召喚獣カリギュラ
function c13529466.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,true,true)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c13529466.aclimit1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c13529466.aclimit2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c13529466.econ1)
	e3:SetValue(c13529466.elimit)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetOperation(c13529466.aclimit3)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetOperation(c13529466.aclimit4)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCondition(c13529466.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--attack limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetCondition(c13529466.atkcon)
	e7:SetTarget(c13529466.atktg)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_ATTACK_ANNOUNCE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c13529466.checkop)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function c13529466.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(13529466,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c13529466.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(13529466)
end
function c13529466.econ1(e)
	return e:GetHandler():GetFlagEffect(13529466)~=0
end
function c13529466.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(13529467,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c13529466.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(13529467)
end
function c13529466.econ2(e)
	return e:GetHandler():GetFlagEffect(13529467)~=0
end
function c13529466.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c13529466.atkcon(e)
	return e:GetHandler():GetFlagEffect(13529468)~=0
end
function c13529466.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c13529466.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(13529468)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(13529468,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
