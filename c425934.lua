--強欲ゴブリン
function c425934.initial_effect(c)
	--discard limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCode(EFFECT_CANNOT_DISCARD_HAND)
	e1:SetTarget(c425934.dislimit)
	c:RegisterEffect(e1)
end
function c425934.dislimit(e,c,re,r)
	return re and re:IsActivated() and r==REASON_COST
end
