--Sin パラレルギア
function c74509280.initial_effect(c)
	--sin territory
	c:SetUniqueOnField(1,1,c74509280.uqfilter,LOCATION_MZONE)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c74509280.synlimit)
	e1:SetTargetRange(1,1)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
end
function c74509280.sfilter(c)
	return c:IsOriginalCodeRule(598988,1710476,9433350,36521459,37115575,55343236) and not c:IsDisabled()
end
function c74509280.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),75223115)
		and Duel.IsExistingMatchingCard(c74509280.sfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		return c:IsCode(74509280)
	else
		return false
	end
end
function c74509280.synlimit(e,c)
	return c:IsSetCard(0x23)
end
