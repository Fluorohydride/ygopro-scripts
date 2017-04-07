--Sin スターダスト・ドラゴン
function c36521459.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsSetCard,0x23),LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c36521459.spcon)
	e1:SetOperation(c36521459.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c36521459.descon)
	c:RegisterEffect(e7)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c36521459.antarget)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--spson
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.FALSE)
	c:RegisterEffect(ea)
end
function c36521459.spfilter(c)
	return c:IsCode(44508094) and c:IsAbleToRemoveAsCost()
end
function c36521459.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c36521459.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c36521459.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c36521459.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c36521459.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c36521459.antarget(e,c)
	return c~=e:GetHandler()
end
