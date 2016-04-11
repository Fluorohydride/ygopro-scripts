--サイバー・オーガ・2
function c37057012.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,64268668,2,false,false)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37057012.atkcon)
	e1:SetValue(c37057012.atkval)
	c:RegisterEffect(e1)
end
function c37057012.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function c37057012.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()/2
end
