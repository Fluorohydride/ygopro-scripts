--ソウル・レヴィ
function c87844926.initial_effect(c)
	c:SetUniqueOnField(1,0,87844926)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--deckdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c87844926.ddcon)
	e2:SetOperation(c87844926.ddop)
	c:RegisterEffect(e2)
	aux.RegisterEachTimeEvent(c,EVENT_SPSUMMON_SUCCESS,c87844926.cfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c87844926.ddcon2)
	e3:SetOperation(c87844926.ddop2)
	c:RegisterEffect(e3)
end
function c87844926.cfilter(c,e,tp)
	return c:IsSummonPlayer(1-tp)
end
function c87844926.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87844926.cfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c87844926.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
function c87844926.ddcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(87844926)>0
end
function c87844926.ddop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(87844926)
	e:GetHandler():ResetFlagEffect(87844926)
	Duel.DiscardDeck(1-tp,ct*3,REASON_EFFECT)
end
