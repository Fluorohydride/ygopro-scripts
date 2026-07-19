--ヒゲアンコウ
function c92084010.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c92084010.condition)
	c:RegisterEffect(e1)
end
function c92084010.condition(e,c)
	local ec=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_WATER) and (ec:IsFaceup() or c:GetControler()==ec:GetControler())
end
