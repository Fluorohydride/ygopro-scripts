--闇の芸術家
function c72520073.initial_effect(c)
	--defdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c72520073.defcon)
	e1:SetValue(c72520073.defval)
	c:RegisterEffect(e1)
end
function c72520073.defcon(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c==Duel.GetAttackTarget() and bc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c72520073.defval(e,c)
	return math.ceil(e:GetHandler():GetDefense()/2)
end
