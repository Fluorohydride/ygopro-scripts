--星輝士の因子
function c81810441.initial_effect(c)
	aux.AddEquipProcedure(c,0,aux.FilterBoolFunction(Card.IsSetCard,0x9c),c81810441.eqlimit)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c81810441.efilter)
	c:RegisterEffect(e5)
	--selfdes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c81810441.descon)
	c:RegisterEffect(e6)
end
function c81810441.eqlimit(e,c)
	return c:IsSetCard(0x9c) and c:GetControler()==e:GetHandler():GetControler()
end
function c81810441.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c81810441.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x9c)
end
function c81810441.descon(e)
	return Duel.IsExistingMatchingCard(c81810441.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
