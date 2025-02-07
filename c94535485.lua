--手をつなぐ魔人
function c94535485.initial_effect(c)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c94535485.atlimit)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c94535485.defval)
	c:RegisterEffect(e2)
end
function c94535485.atlimit(e,c)
	return c~=e:GetHandler()
end
function c94535485.deffilter(c)
	return c:GetBaseDefense()>=0 and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c94535485.defval(e,c)
	local g=Duel.GetMatchingGroup(c94535485.deffilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseDefense)
end
