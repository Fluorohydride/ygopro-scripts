--Dinomist Ceratops
function c37752990.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c37752990.reptg)
	e2:SetValue(c37752990.repval)
	e2:SetOperation(c37752990.repop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c37752990.spcon)
	c:RegisterEffect(e3)
end
function c37752990.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1e71) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c37752990.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c37752990.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(37752990,0))
end
function c37752990.repval(e,c)
	return c37752990.filter(c,e:GetHandlerPlayer())
end
function c37752990.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c37752990.sdfilter(c)
	return c:GetCode()==37752990 or c:IsFacedown()
end
function c37752990.sdfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x1e71)
end
function c37752990.spcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c37752990.sdfilter2,tp,LOCATION_MZONE,0,1,nil)
		and not	Duel.IsExistingMatchingCard(c37752990.sdfilter,tp,LOCATION_MZONE,0,1,nil)
end
