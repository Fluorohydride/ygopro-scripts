--フュージョン・ゲート
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--fusion
	local e1=FusionSpell.CreateSummonEffect(c,{
		mat_operation_code_map={
			{ [LOCATION_REMOVED] = FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff] = FusionSpell.FUSION_OPERATION_BANISH }
		},
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	c:RegisterEffect(e1)
end
