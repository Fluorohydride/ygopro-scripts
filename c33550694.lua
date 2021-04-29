--フュージョン・ゲート
function c33550694.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion
	local e2=aux.AddFusionEffectProcUltimate(c,{
		mat_filter=Card.IsAbleToRemove,
		mat_operation=aux.FMaterialRemove,
		reg=false
	})
	e2:SetDescription(aux.Stringid(33550694,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	c:RegisterEffect(e2)
end
