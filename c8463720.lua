--DDD剋竜王ベオウルフ
function c8463720.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10af),aux.FilterBoolFunction(Card.IsFusionSetCard,0xaf),true)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf))
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8463720,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c8463720.descon)
	e2:SetTarget(c8463720.destg)
	e2:SetOperation(c8463720.desop)
	c:RegisterEffect(e2)
end
function c8463720.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c8463720.filter(c)
	return c:GetSequence()<5
end
function c8463720.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8463720.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c8463720.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c8463720.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8463720.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
