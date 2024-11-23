--ザ・アキュムレーター
---@param c Card
function c70410002.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c70410002.atkval)
	c:RegisterEffect(e1)
end
function c70410002.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c70410002.atkval(e,c)
	local g=Duel.GetMatchingGroup(c70410002.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLink)*300
end
