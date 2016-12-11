--脳開発研究所
function c85668449.initial_effect(c)
	c:EnableCounterPermit(0x4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e2:SetValue(c85668449.esop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c85668449.ctcon)
	e3:SetOperation(c85668449.ctop)
	c:RegisterEffect(e3)
	--lpcost replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85668449,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_LPCOST_REPLACE)
	e3:SetCondition(c85668449.lrcon)
	e3:SetOperation(c85668449.lrop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c85668449.damp)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c85668449.damop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c85668449.esop(e,c)
	c:RegisterFlagEffect(85668449,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c85668449.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetFlagEffect(85668449)~=0
end
function c85668449.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4,1)
	eg:GetFirst():ResetFlagEffect(85668449)
end
function c85668449.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<ev then return false end
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsRace(RACE_PSYCHO)
end
function c85668449.lrop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4,1)
end
function c85668449.damp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x4)
	e:SetLabel(ct)
end
function c85668449.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.Damage(tp,ct*1000,REASON_EFFECT)
	end
end
