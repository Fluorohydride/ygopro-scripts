--ドラグニティ－アングス
---@param c Card
function c88361177.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(c88361177.pcon)
	c:RegisterEffect(e1)
end
function c88361177.pfilter(c)
	return c:IsSetCard(0x29) and c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function c88361177.pcon(e)
	return e:GetHandler():GetEquipGroup():IsExists(c88361177.pfilter,1,nil)
end
