--ドラゴンに乗るワイバーン
---@param c Card
function c3366982.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,88819587,64428736,true,true)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c3366982.dircon)
	c:RegisterEffect(e2)
end
function c3366982.filter(c)
	return c:IsFaceup() and c:IsAttribute(0xf8)
end
function c3366982.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c3366982.filter,tp,0,LOCATION_MZONE,1,nil)
end
