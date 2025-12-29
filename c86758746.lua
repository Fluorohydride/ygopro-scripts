--アマゾネスの秘術
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.fusop)
	c:RegisterEffect(e2)
end
function s.fusfilter(c)
	return c:IsSetCard(0x4)
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	--Once this turn, if you Fusion Summon an "Amazoness" Fusion Monster this turn, you can also send 1 "Amazoness" monster from your Extra Deck to the GY as material.
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetCountLimit(1)
	e1:SetTargetRange(LOCATION_EXTRA,0)
	e1:SetTarget(function(_,c) return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4) end)
	e1:SetOperation(function() return FusionSpell.FUSION_OPERATION_GRAVE end)
	e1:SetValue(function(extra_material_effect,c) return c and c:IsSetCard(0x4) and c:IsControler(extra_material_effect:GetHandlerPlayer()) end)
	e1:SetLabel(1)  --- at most 1 material per fusion effect
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
