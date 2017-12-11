--フレイム・アドミニスター
function c49847524.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,49847524)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,2)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	e1:SetValue(800)
	c:RegisterEffect(e1)
end
