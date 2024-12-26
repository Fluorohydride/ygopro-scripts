--破滅の儀式
---@param c Card
function c52913738.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,30646525)
	--To Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52913738,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c52913738.regcon)
	e1:SetCost(aux.bfgcost)
	e1:SetOperation(c52913738.regop)
	c:RegisterEffect(e1)
end
function c52913738.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c52913738.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e1:SetValue(LOCATION_DECK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
