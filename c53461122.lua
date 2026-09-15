--ガイアフレーム
function c53461122.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c53461122.condition)
	c:RegisterEffect(e1)
end
function c53461122.condition(e,c)
	local ec=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_NORMAL) and (ec:IsFaceup() or c:GetControler()==ec:GetControler())
end
