--聖霊獣騎 ガイアペライオ
---@param c Card
function c56655675.initial_effect(c)
	c:EnableReviveLimit()
	local mat_list={}
	for i=0,2 do
		table.insert(mat_list,aux.FilterBoolFunction(Card.IsFusionSetCard,0xb5|(0x1000<<i)))
	end
	aux.AddFusionProcMix(c,false,false,table.unpack(mat_list))
	aux.AddContactFusionProcedure(c,c56655675.cfilter,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST):SetValue(SUMMON_VALUE_SELF)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c56655675.condition)
	e3:SetOperation(c56655675.operation)
	c:RegisterEffect(e3)
end
function c56655675.cfilter(c)
	return c:IsFusionSetCard(0x40b5,0x10b5,0x20b5)
		and c:IsAbleToRemoveAsCost()
end
function c56655675.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c56655675.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c56655675.discon)
	e1:SetCost(c56655675.discost)
	e1:SetTarget(c56655675.distg)
	e1:SetOperation(c56655675.disop)
	e1:SetReset(RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE)
	e:GetHandler():RegisterEffect(e1)
end
function c56655675.discon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c56655675.filter(c)
	return c:IsSetCard(0xb5) and c:IsAbleToRemoveAsCost()
end
function c56655675.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56655675.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c56655675.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c56655675.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c56655675.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
