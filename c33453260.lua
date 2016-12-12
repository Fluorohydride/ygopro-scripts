--コミックハンド
function c33453260.initial_effect(c)
	aux.AddEquipProcedure(c,1,Card.IsControlerCanBeChanged,c33453260.eqlimit,c33453260.condition,c33453260.target)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetValue(c33453260.cval)
	c:RegisterEffect(e3)
	--change type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetValue(TYPE_TOON)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c33453260.dircon)
	c:RegisterEffect(e5)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c33453260.descon)
	c:RegisterEffect(e6)
end
function c33453260.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c33453260.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33453260.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c33453260.target(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.GetFirstTarget(),1,0,0)
end
function c33453260.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function c33453260.cval(e,c)
	return e:GetHandlerPlayer()
end
function c33453260.dirfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c33453260.dircon(e)
	return not Duel.IsExistingMatchingCard(c33453260.dirfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c33453260.descon(e)
	return not Duel.IsExistingMatchingCard(c33453260.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
