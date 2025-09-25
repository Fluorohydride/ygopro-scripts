--サイバネティック・フュージョン・サポート
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(s.chain_target)
	e1:SetOperation(s.chain_operation)
	e1:SetValue(aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE))
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil,te)
end
function s.chain_operation(e,te,tp,tc,mat,sumtype,sumpos)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummonStep(tc,sumtype,tp,tp,false,false,sumpos)
end