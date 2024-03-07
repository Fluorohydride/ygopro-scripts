--アモルファスP
function c23160024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe0))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c23160024.drcon)
	e4:SetOperation(c23160024.drop)
	c:RegisterEffect(e4)
	aux.RegisterEachTimeEvent(c,EVENT_RELEASE,c23160024.cfilter)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e0:SetCondition(c23160024.drcon2)
	e0:SetOperation(c23160024.drop2)
	c:RegisterEffect(e0)
	--ritural
	local e5=aux.AddRitualProcEqualCode(c,98287529,nil,nil,c23160024.mfilter,true)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(0)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	c:RegisterEffect(e5)
end
function c23160024.cfilter(c,e,tp)
	return c:IsPreviousSetCard(0xe0) and c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c23160024.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23160024.cfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c23160024.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c23160024.drcon2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(23160024)>0 and Duel.IsPlayerCanDraw(tp) then
		return true
	else
		e:GetHandler():ResetFlagEffect(23160024)
		return false
	end
end
function c23160024.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	local ct=e:GetHandler():GetFlagEffect(23160024)
	e:GetHandler():ResetFlagEffect(23160024)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c23160024.mfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
