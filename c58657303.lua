--墓守の霊術師
function c58657303.initial_effect(c)
	--fusion summon
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),
		include_this_card=true,
		reg=false
	})
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,58657303)
	e1:SetCondition(c58657303.condition)
	c:RegisterEffect(e1)
end
function c58657303.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(47355498)
end
