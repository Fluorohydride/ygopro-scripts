--古代の機械城
function c92001300.initial_effect(c)
	c:EnableCounterPermit(0xb)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c92001300.addcon)
	e3:SetOperation(c92001300.addc)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	aux.RegisterEachTimeEvent(c,EVENT_SUMMON_SUCCESS,aux.TRUE)
	aux.RegisterEachTimeEvent(c,EVENT_MSET,aux.TRUE)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c92001300.addcon2)
	e5:SetOperation(c92001300.addc2)
	c:RegisterEffect(e5)
	--summon proc
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(92001300,0))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SUMMON_PROC)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7))
	e6:SetCondition(c92001300.sumcon)
	e6:SetOperation(c92001300.sumop)
	e6:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e6)
end
function c92001300.addcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsChainSolving()
end
function c92001300.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xb,1)
end
function c92001300.addcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(92001300)>0
end
function c92001300.addc2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(92001300)
	e:GetHandler():ResetFlagEffect(92001300)
	e:GetHandler():AddCounter(0xb,ct)
end
function c92001300.sumcon(e,c,minc)
	if c==nil then return e:GetHandler():IsReleasable(REASON_SUMMON) end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and e:GetHandler():GetCounter(0xb)>=mi and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c92001300.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetMaterial(Group.FromCards(e:GetHandler()))
	Duel.Release(e:GetHandler(),REASON_SUMMON+REASON_MATERIAL)
end
