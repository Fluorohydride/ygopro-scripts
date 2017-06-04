--究極恐獣
function c15894048.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c15894048.catg)
	e1:SetCondition(c15894048.cacon)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c15894048.catg(e,c)
	return not c:IsCode(15894048)
end
function c15894048.cfilter(c)
	if not c:IsFaceup() or not c:IsCode(15894048) or not c:IsAttackable() then return false end
	local ag,direct=c:GetAttackableTarget()
	return ag:GetCount()>0 or direct
end
function c15894048.cacon(e)
	return Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2
		and Duel.IsExistingMatchingCard(c15894048.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
