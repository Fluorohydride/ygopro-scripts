--竜宮の白タウナギ
function c37953640.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c37953640.synlimit)
	c:RegisterEffect(e1)
end
c37953640.tuner_filter=aux.FilterBoolFunction(Card.IsRace,RACE_FISH)
function c37953640.synlimit(e,c)
	return c:IsRace(RACE_FISH)
end
